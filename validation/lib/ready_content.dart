import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dto/content_validation.dart';
import 'package:dto/dto.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as path;

String canonical(Object? value) {
  Object? normalize(Object? item) {
    if (item is Map) {
      final keys = item.keys.cast<String>().toList()..sort();
      return {for (final key in keys) key: normalize(item[key])};
    }
    if (item is List) return item.map(normalize).toList();
    return item;
  }

  return jsonEncode(normalize(value));
}

class ReadyContent {
  final Directory root;
  ReadyContent(this.root);

  Future<void> validate() async {
    final data = Directory(path.join(root.path, 'data'));
    if (await FileSystemEntity.type(data.path, followLinks: false) !=
            FileSystemEntityType.directory ||
        await FileSystemEntity.type(_file('').path, followLinks: false) !=
            FileSystemEntityType.directory) {
      throw const FormatException('Unsafe or missing data directory');
    }
    var count = 0;
    await for (final entry in Directory(
      _file('').path,
    ).list(recursive: true, followLinks: false)) {
      if ((entry is! File && entry is! Directory) || ++count > 100000)
        throw const FormatException('Unsafe content tree');
    }
    final people = await _collection('people', PersonDto.fromJson);
    final tales = await _collection('tales', TaleDto.fromJson);
    final accepted = <String>{
      'people/list.json',
      'people/list.json.gz',
      'tales/list.json',
      'tales/list.json.gz',
    };
    final directories = <String>{'people', 'tales'};
    final ids = <int>{};
    for (final person in people) {
      final prefix = 'people/${person.id}';
      directories.add(prefix);
      final photo = await _pair(
        prefix,
        'photo.original.',
        'photo.thumbnail.jpg',
        accepted,
      );
      _require(
        const ContentReadinessValidator().validatePerson(
          PersonReadinessInput.fromDto(person, photo: photo),
        ),
      );
      ids.add(person.id);
    }
    for (final tale in tales) {
      final prefix = 'tales/${tale.id}';
      directories.addAll([prefix, '$prefix/img']);
      final files = await Directory(_file('$prefix/img').path)
          .list(followLinks: false)
          .toList();
      final indices = <int>{};
      for (final file in files) {
        final match = RegExp(r'^(0|[1-9][0-9]*)\.original\.[a-z0-9]{1,10}$')
            .firstMatch(path.basename(file.path));
        if (match != null && !indices.add(int.parse(match[1]!))) {
          throw const FormatException('Duplicate image original');
        }
      }
      final images = <IndexedImageEvidence>[];
      for (final index in indices.toList()..sort()) {
        images.add(
          IndexedImageEvidence(
            index: index,
            media: await _pair(
              '$prefix/img',
              '$index.original.',
              '$index.thumbnail.jpg',
              accepted,
            ),
          ),
        );
      }
      var audio = const MediaPairEvidence();
      if (tale.audio != null) {
        directories.add('$prefix/audio');
        final original = await _original('$prefix/audio', 'original.');
        final thumbnail = '$prefix/audio/thumbnail.m4a';
        accepted.addAll([original, thumbnail]);
        await _audio(original);
        final duration = await _audio(thumbnail);
        if ((duration - tale.audio!.duration).abs() >
            const Duration(milliseconds: 50))
          throw FormatException(
            'Audio duration mismatch: $thumbnail; stored '
            '${tale.audio!.duration.inMicroseconds} us, measured ${duration.inMicroseconds} us',
          );
        audio = MediaPairEvidence(
          original: await _evidence(original),
          thumbnail: await _evidence(thumbnail),
        );
      }
      final input = TaleReadinessInput.fromDto(
        tale,
        images: images,
        audioFiles: audio,
      );
      for (final members in input.crew?.values ?? <List<int>>[]) {
        if (members.length != members.toSet().length)
          throw const FormatException('Duplicate crew member');
      }
      _require(
        const ContentReadinessValidator().validateTale(
          input,
          readyPersonIds: ids,
        ),
      );
    }
    await for (final entry in Directory(
      _file('').path,
    ).list(recursive: true, followLinks: false)) {
      final name = path
          .relative(entry.path, from: _file('').path)
          .split(path.separator)
          .join('/');
      if (entry is File && accepted.contains(name)) continue;
      if (entry is Directory && directories.contains(name)) continue;
      throw FormatException('Unexpected ready-content entry: $name');
    }
  }

  Future<List<T>> _collection<T extends ToJsonItem>(
    String kind,
    T Function(Map<String, dynamic>) decode,
  ) async {
    final raw =
        jsonDecode(await _file('$kind/list.json').readAsString()) as List;
    final ids = <int>{};
    final items = <T>[];
    for (final record in raw) {
      final data = record as Map<String, dynamic>;
      final id = data['id'];
      if (id is! int ||
          id < 0 ||
          id == TaleDto.stubId ||
          id > 9007199254740991 ||
          !ids.add(id)) {
        throw const FormatException('Invalid or duplicate ready ID');
      }
      final item = decode(data);
      _shape(data, item.toJson());
      items.add(item);
    }
    final production = jsonDecode(
      utf8.decode(gzip.decode(await _file('$kind/list.json.gz').readAsBytes())),
    );
    if (canonical(production) !=
        canonical(items.map((item) => item.toProdJson()).toList())) {
      throw const FormatException(
        'Production gzip does not match the ready projection',
      );
    }
    return items;
  }

  void _shape(Object? raw, Object? normalized) {
    if (raw == null) return;
    if (raw is Map && normalized is Map) {
      for (final key in raw.keys) {
        if (!normalized.containsKey(key) && raw[key] != null)
          throw FormatException('Unknown ready field: $key');
        _shape(raw[key], normalized[key]);
      }
    } else if (raw is List && normalized is List) {
      if (raw.length != normalized.length)
        throw const FormatException('Lossy collection decoding');
      for (var index = 0; index < raw.length; index++) {
        _shape(raw[index], normalized[index]);
      }
    } else if (raw is num && normalized is int && raw is! int) {
      throw const FormatException('Fractional integer metadata');
    }
  }

  Future<String> _original(String prefix, String stem) async {
    final files = await Directory(_file(prefix).path)
        .list(followLinks: false)
        .toList();
    final originals = files
        .whereType<File>()
        .where((file) => path.basename(file.path).startsWith(stem))
        .toList();
    if (originals.length != 1)
      throw FormatException('Missing or ambiguous original: $prefix/$stem');
    return '$prefix/${path.basename(originals.single.path)}';
  }

  Future<MediaPairEvidence> _pair(
    String prefix,
    String stem,
    String thumbnail,
    Set<String> accepted,
  ) async {
    final original = await _original(prefix, stem);
    final small = '$prefix/$thumbnail';
    accepted.addAll([original, small]);
    return MediaPairEvidence(
      original: await _image(original),
      thumbnail: await _image(small),
    );
  }

  Future<MediaFileEvidence> _image(String name) async {
    final bytes = await _file(name).readAsBytes();
    final decoder = image.findDecoderForNamedImage(name);
    if (decoder == null ||
        !decoder.isValidFile(bytes) ||
        decoder.decode(bytes) == null) {
      throw FormatException('Invalid image: $name');
    }
    return _evidence(name);
  }

  Future<MediaFileEvidence> _evidence(String name) async => MediaFileEvidence(
    byteLength: await _file(name).length(),
    extension: path.extension(name).substring(1),
    isDecodable: true,
  );

  Future<Duration> _audio(String name) async {
    final file = _file(name);
    final output = await _command('ffprobe', [
      '-v',
      'error',
      '-select_streams',
      'a:0',
      '-show_entries',
      'stream=codec_type:format=duration',
      '-of',
      'json',
      file.path,
    ]);
    final data = jsonDecode(output) as Map<String, dynamic>;
    final streams = data['streams'] as List;
    final seconds = double.tryParse(
      (data['format'] as Map)['duration'] as String? ?? '',
    );
    if (streams.length != 1 ||
        streams.single['codec_type'] != 'audio' ||
        seconds == null ||
        !seconds.isFinite ||
        seconds <= 0) {
      throw FormatException('Invalid audio: $name');
    }
    await _command('ffmpeg', [
      '-v',
      'error',
      '-xerror',
      '-nostdin',
      '-i',
      file.path,
      '-map',
      '0:a:0',
      '-f',
      'null',
      '-',
    ]);
    return Duration(
      microseconds: (seconds * Duration.microsecondsPerSecond).round(),
    );
  }

  Future<String> _command(String executable, List<String> arguments) async {
    final process = await Process.start(executable, arguments);
    var expired = false;
    final timer = Timer(const Duration(minutes: 2), () {
      expired = true;
      process.kill(ProcessSignal.sigkill);
    });
    Future<List<int>> collect(Stream<List<int>> stream) async {
      final result = <int>[];
      await for (final bytes in stream) {
        if (result.length + bytes.length > 1024 * 1024) {
          process.kill(ProcessSignal.sigkill);
          throw const FormatException('Media tool output exceeded limit');
        }
        result.addAll(bytes);
      }
      return result;
    }

    try {
      await process.stdin.close();
      final outputs = await Future.wait([
        collect(process.stdout),
        collect(process.stderr),
      ]);
      if (await process.exitCode != 0 || expired)
        throw FormatException('$executable failed or timed out');
      return utf8.decode(outputs.first);
    } finally {
      timer.cancel();
    }
  }

  File _file(String relative) =>
      File(path.join(root.path, 'data', '4', relative));
  void _require(List<ContentValidationIssue> issues) {
    if (issues.isNotEmpty)
      throw FormatException(
        'Readiness: ${issues.map((issue) => '${issue.field}:${issue.code.name}').join(', ')}',
      );
  }
}
