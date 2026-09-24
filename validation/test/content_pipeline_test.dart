import 'dart:convert';
import 'dart:io';

import 'package:dto/dto.dart';
import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as image;
import 'package:test/test.dart';
import 'package:validation/validate_data_4.dart';
import 'package:validation/mobile_delivery.dart';
import 'package:validation/branch_ids.dart';

void main() {
  late Directory root;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('content_pipeline_');
    await fixture(root);
  });
  tearDown(() => root.delete(recursive: true));

  test(
    'CLI rejects invalid metadata with assertions disabled and matching gzip',
    () async {
      final file = File('${root.path}/data/4/people/list.json');
      final records = jsonDecode(await file.readAsString()) as List;
      (records.single as Map)['name'] = '';
      final encoded = jsonEncode(records);
      await file.writeAsString(encoded);
      await File('${file.path}.gz')
          .writeAsBytes(gzip.encode(utf8.encode(encoded)));
      final before = await snapshot(root);
      final result = await Process.run(Platform.resolvedExecutable, [
        'run',
        'bin/validate_data_4.dart',
        root.path,
      ]);
      expect(result.exitCode, 1);
      expect(result.stdout.toString(), contains('Readiness: name:'));
      expect(await snapshot(root), before);
    },
  );

  for (final damage in [
    'none',
    'history',
    'receipt-target',
    'reference',
    'media-size',
  ]) {
    test('authoring history receipts and typed references: $damage', () async {
      final file = await draft(root);
      final record =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final bytes = utf8.encode('retained draft media');
      final digest = sha256.convert(bytes).toString();
      final media = File('${file.parent.path}/media/$digest.jpg');
      await media.parent.create();
      await media.writeAsBytes(bytes);
      (record['payload'] as Map)['photo'] = {
        'original': {
          'path': 'media/$digest.jpg',
          'sha256': digest,
          'byteLength': damage == 'media-size' ? 1 : bytes.length,
        },
      };
      final history = File('${file.parent.path}/history/1.json');
      await history.parent.create();
      await history.writeAsString(jsonEncode(record));
      (record['manifest'] as Map)['revision'] = 2;
      await file.writeAsString(jsonEncode(record));
      final applied = Directory(
        '${root.path}/authoring/v1/applied/${'a' * 32}',
      );
      await applied.parent.create(recursive: true);
      await file.parent.rename(applied.path);
      await File('${applied.path}/receipt.json').writeAsString(
        jsonEncode({
          'schemaVersion': 1,
          'draftId': 'a' * 32,
          'kind': 'person',
          'revision': 2,
          'targetId': damage == 'receipt-target' ? 3.5 : 3,
          'resultFingerprint': 'b' * 64,
          'appliedAt': '2026-01-01T00:00:00.000Z',
        }),
      );
      if (damage == 'history')
        await File('${applied.path}/history/1.json').delete();
      final tale = File(
        '${root.path}/authoring/v1/drafts/${'c' * 32}/manifest.json',
      );
      await tale.parent.create(recursive: true);
      await tale.writeAsString(
        jsonEncode({
          'manifest': {
            ...record['manifest'] as Map,
            'id': 'c' * 32,
            'kind': 'tale',
            'revision': 1,
          },
          'payload': {
            'text': {
              'items': [
                {'kind': 'text', 'text': null},
              ],
            },
            'crew': {
              'author': [
                {
                  'kind': 'draft',
                  'draftId': (damage == 'reference' ? 'd' : 'a') * 32,
                },
              ],
            },
          },
        }),
      );
      final result = await Data4Validator(root.path).validate();
      expect(
        result.success,
        damage == 'none',
        reason: result.errors.join('\n'),
      );
    });
  }

  test(
    'delivery rejects an existing destination and leaves it untouched',
    () async {
      final parent = await Directory.systemTemp.createTemp(
        'existing_delivery_',
      );
      addTearDown(() => parent.delete(recursive: true));
      final marker = File('${parent.path}/preserve');
      await marker.writeAsString('owned');
      await expectLater(
        MobileDelivery().build(root, parent),
        throwsFormatException,
      );
      expect(await marker.readAsString(), 'owned');
      await expectLater(
        MobileDelivery().build(root, Directory('${root.path}/output')),
        throwsFormatException,
      );
    },
  );

  test(
    'real audio decoding accepts measured metadata and rejects corruption',
    () async {
      final audio = Directory('${root.path}/data/4/tales/7/audio');
      await audio.create();
      final original = File('${audio.path}/original.wav');
      final thumbnail = File('${audio.path}/thumbnail.m4a');
      final generated = await Process.run('ffmpeg', [
        '-v',
        'error',
        '-f',
        'lavfi',
        '-i',
        'sine=frequency=440:duration=1',
        original.path,
      ]);
      expect(generated.exitCode, 0, reason: generated.stderr.toString());
      final encoded = await Process.run('ffmpeg', [
        '-v',
        'error',
        '-i',
        original.path,
        '-t',
        '0.5',
        '-c:a',
        'aac',
        thumbnail.path,
      ]);
      expect(encoded.exitCode, 0, reason: encoded.stderr.toString());
      final file = File('${root.path}/data/4/tales/list.json');
      final data =
          (jsonDecode(await file.readAsString()) as List).single
              as Map<String, dynamic>;
      data['tags'] = ['text', 'audio'];
      data['audio'] = {
        'duration': 500000,
        'file_size': await thumbnail.length(),
      };
      await writeCollection(root, 'tales', [TaleDto.fromJson(data)]);
      expect((await Data4Validator(root.path).validate()).errors, isEmpty);
      (data['audio'] as Map)['duration'] = 1000000;
      await writeCollection(root, 'tales', [TaleDto.fromJson(data)]);
      final wrongSource = await Data4Validator(root.path).validate();
      expect(wrongSource.success, isFalse);
      expect(
        wrongSource.errors.single,
        contains('tales/7/audio/thumbnail.m4a'),
      );
      (data['audio'] as Map)['duration'] = 500000;
      await writeCollection(root, 'tales', [TaleDto.fromJson(data)]);
      final bytes = await thumbnail.readAsBytes();
      await thumbnail.writeAsBytes(List.filled(bytes.length, 0));
      expect((await Data4Validator(root.path).validate()).success, isFalse);
    },
  );

  test('real Git history rejects independently allocated IDs', () async {
    Future<String> git(List<String> arguments) async {
      final result = await Process.run(
        'git',
        [
          '-c',
          'user.name=Fixture',
          '-c',
          'user.email=fixture@example.invalid',
          '-c',
          'commit.gpgsign=false',
          '-c',
          'core.hooksPath=/dev/null',
          ...arguments,
        ],
        workingDirectory: root.path,
        environment: {
          'GIT_CONFIG_NOSYSTEM': '1',
          'GIT_CONFIG_GLOBAL': '/dev/null',
        },
      );
      expect(result.exitCode, 0, reason: result.stderr.toString());
      return result.stdout.toString().trim();
    }

    await git(['init', '--initial-branch=fixture']);
    await git(['add', '.']);
    await git(['commit', '-m', 'ancestor']);
    final ancestor = await git(['rev-parse', 'HEAD']);
    final file = File('${root.path}/data/4/people/list.json');
    final records = jsonDecode(await file.readAsString()) as List;
    records.add({...records.first as Map, 'id': 4});
    await file.writeAsString(jsonEncode(records));
    await git(['add', '.']);
    await git(['commit', '-m', 'base allocation']);
    final base = await git(['rev-parse', 'HEAD']);
    await git(['checkout', '--detach', ancestor]);
    await file.writeAsString(jsonEncode(records));
    await git(['add', '.']);
    await git(['commit', '-m', 'head allocation']);
    final head = await git(['rev-parse', 'HEAD']);
    await expectLater(
      validateBranchIds(root, ancestor, base, head),
      throwsFormatException,
    );
    await validateBranchIds(root, ancestor, ancestor, head);
  });

  test('delivery allowlist is unchanged by draft-only edits and readable by mobile DTOs', () async {
    final parent = await Directory.systemTemp.createTemp('mobile_delivery_');
    addTearDown(() => parent.delete(recursive: true));
    final before = Directory('${parent.path}/before');
    final after = Directory('${parent.path}/after');
    await MobileDelivery().build(root, before);
    await draft(root);
    await MobileDelivery().build(root, after);
    Future<Map<String, String>> relative(Directory folder) async => {
      for (final entry in (await snapshot(folder)).entries)
        entry.key.substring(folder.path.length): entry.value,
    };
    expect(await relative(before), await relative(after));
    expect((await relative(after)).keys.toSet(), {
      '/data/4/people/list.json.gz',
      '/data/4/tales/list.json.gz',
      '/data/4/people/3/photo.thumbnail.jpg',
      '/data/4/tales/7/img/0.thumbnail.jpg',
    });
    final tales = DTOCompression.decompressTales(
      await File('${after.path}/data/4/tales/list.json.gz').readAsBytes(),
    );
    expect(tales.single.isHidden, isTrue);
    expect(tales.single.adminConfig!.comment, isNull);
    expect(
      DTOCompression.decompressPeople(
        await File('${after.path}/data/4/people/list.json.gz').readAsBytes(),
      ).single.id,
      3,
    );
  });

  test('delivery refuses invalid content before creating output', () async {
    final parent = await Directory.systemTemp.createTemp('mobile_delivery_');
    addTearDown(() => parent.delete(recursive: true));
    final output = Directory('${parent.path}/blocked');
    await File('${root.path}/data/4/tales/7/img/0.thumbnail.jpg')
        .writeAsString('broken');
    await expectLater(
      MobileDelivery().build(root, output),
      throwsFormatException,
    );
    expect(await output.exists(), isFalse);
  });

  test('independent allocations collide but existing edits do not', () {
    expect(collidingIds({1}, {1, 2}, {1, 2, 3}), {2});
    expect(collidingIds({1}, {1, 2}, {1, 3}), isEmpty);
    expect(collidingIds({}, {7}, {7}), {7});
  });

  test('incomplete saved draft passes without changing mobile files', () async {
    final before = await snapshot(Directory('${root.path}/data'));
    await draft(root);
    expect((await Data4Validator(root.path).validate()).errors, isEmpty);
    expect(await snapshot(Directory('${root.path}/data')), before);
  });

  for (final damage in [
    'version',
    'revision',
    'pending',
    'promotion',
    'receipt',
    'media-hash',
    'unknown',
  ]) {
    test('rejects authoring $damage and retains evidence', () async {
      final manifest = await draft(root);
      final record =
          jsonDecode(await manifest.readAsString()) as Map<String, dynamic>;
      switch (damage) {
        case 'version':
          (record['manifest'] as Map)['schemaVersion'] = 2;
        case 'revision':
          (record['manifest'] as Map)['revision'] = 2;
        case 'pending':
          await Directory('${manifest.parent.path}/.pending').create();
        case 'promotion':
          await File('${root.path}/authoring/v1/.promotion')
              .writeAsString('interrupted');
        case 'receipt':
          await File('${manifest.parent.path}/receipt.json')
              .writeAsString('{}');
        case 'media-hash':
          final file = File('${manifest.parent.path}/media/${'0' * 64}.jpg');
          await file.parent.create();
          await file.writeAsString('wrong hash');
        case 'unknown':
          (record['payload'] as Map)['unexpected'] = true;
      }
      await manifest.writeAsString(jsonEncode(record));
      final before = await snapshot(root);
      expect((await Data4Validator(root.path).validate()).success, isFalse);
      expect(await snapshot(root), before);
    });
  }

  for (final damage in [
    'name',
    'tags',
    'crew',
    'duplicate',
    'fractional',
    'nested-fractional',
    'gzip',
    'media',
    'extra',
    'symlink',
  ]) {
    test('rejects $damage without rewriting content', () async {
      final file = File('${root.path}/data/4/tales/list.json');
      final records = jsonDecode(await file.readAsString()) as List;
      final tale = records.single as Map<String, dynamic>;
      switch (damage) {
        case 'name':
          tale['name'] = '';
        case 'tags':
          tale['tags'] = [];
        case 'crew':
          tale['crew'] = {
            'authors': [404],
          };
        case 'duplicate':
          records.add(Map<String, dynamic>.of(tale));
        case 'fractional':
          tale['id'] = 7.5;
        case 'nested-fractional':
          (tale['text'] as Map)['min_reading_time'] = 1.5;
        case 'gzip':
          await File('${file.path}.gz')
              .writeAsBytes(gzip.encode(utf8.encode('[]')));
        case 'media':
          await File('${root.path}/data/4/tales/7/img/0.thumbnail.jpg')
              .writeAsString('broken');
        case 'extra':
          await File('${root.path}/data/4/tales/7/unknown')
              .writeAsString('preserve');
        case 'symlink':
          await Link('${root.path}/data/4/tales/7/link').create(file.path);
      }
      await file.writeAsString(jsonEncode(records));
      final before = await snapshot(root);
      expect((await Data4Validator(root.path).validate()).success, isFalse);
      expect(await snapshot(root), before);
    });
  }

  test('hidden editorial metadata matches the production projection', () async {
    final result = await Data4Validator(root.path).validate();
    expect(result.errors, isEmpty);
  });

  test('unexpected files fail without being deleted', () async {
    for (final relative in ['7/.DS_Store', '7/img/.DS_Store']) {
      final file = File('${root.path}/data/4/tales/$relative');
      await file.writeAsString('preserve');
      expect((await Data4Validator(root.path).validate()).success, isFalse);
      expect(await file.readAsString(), 'preserve');
    }
  });
}

Future<void> fixture(Directory root) async {
  final person = PersonDto.fromJson({
    'id': 3,
    'name': 'Fixture Person',
    'surname': '',
    'gender': 'female',
    'create_date': '2026-01-01T00:00:00.000Z',
  });
  final tale = TaleDto.fromJson({
    'id': 7,
    'name': 'Fixture Tale',
    'summary': 'A fixture summary. ' * 8,
    'create_date': '2026-01-01T00:00:00.000Z',
    'tags': ['text'],
    'text': {
      'items': ['[0]', 'Fixture text.'],
      'min_reading_time': 1,
      'max_reading_time': 2,
    },
    'admin_config': {
      'is_hidden': true,
      'is_reviewed': true,
      'comment': 'Editorial only',
    },
    'crew': {
      'authors': [3],
    },
  });
  await writeCollection(root, 'people', [person]);
  await writeCollection(root, 'tales', [tale]);
  final bytes = image.encodeJpg(image.Image(width: 4, height: 4));
  for (final relative in [
    'people/3/photo.original.jpg',
    'people/3/photo.thumbnail.jpg',
    'tales/7/img/0.original.jpg',
    'tales/7/img/0.thumbnail.jpg',
  ]) {
    final file = File('${root.path}/data/4/$relative');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
  }
}

Future<void> writeCollection(
  Directory root,
  String kind,
  List<ToJsonItem> items,
) async {
  final file = File('${root.path}/data/4/$kind/list.json');
  await file.parent.create(recursive: true);
  await file.writeAsString(
    jsonEncode(items.map((item) => item.toJson()).toList()),
  );
  await File('${file.path}.gz').writeAsBytes(
    DTOCompression<ToJsonItem>().compress(items, (item) => item.toProdJson()),
  );
}

Future<Map<String, String>> snapshot(Directory root) async => {
  await for (final entry in root.list(recursive: true, followLinks: false))
    if (entry is File) entry.path: base64Encode(await entry.readAsBytes()),
};

Future<File> draft(Directory root) async {
  final file = File(
    '${root.path}/authoring/v1/drafts/${'a' * 32}/manifest.json',
  );
  await file.parent.create(recursive: true);
  await file.writeAsString(
    jsonEncode({
      'manifest': {
        'schemaVersion': 1,
        'id': 'a' * 32,
        'kind': 'person',
        'revision': 1,
        'createdAt': '2026-01-01T00:00:00.000Z',
        'savedAt': '2026-01-01T00:00:00.000Z',
      },
      'payload': {'name': ''},
    }),
  );
  return file;
}
