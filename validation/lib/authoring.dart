import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dto/dto.dart';
import 'package:path/path.dart' as path;

class AuthoringValidator {
  final Directory root;
  AuthoringValidator(this.root);

  Future<void> validate() async {
    final authoring = Directory(path.join(root.path, 'authoring'));
    final type = await FileSystemEntity.type(
      authoring.path,
      followLinks: false,
    );
    if (type == FileSystemEntityType.notFound) return;
    _require(type == FileSystemEntityType.directory);
    final files = <String, File>{};
    final folders = <String>{};
    final names = <String>{};
    final ids = <String>{};
    final records =
        <
          String,
          ({
            Map<String, dynamic> manifest,
            List<Map<String, dynamic>> media,
            List<Map<String, dynamic>> refs,
          })
        >{};
    final targets = <String>{};
    await for (final entry in authoring.list(
      recursive: true,
      followLinks: false,
    )) {
      final name = path
          .relative(entry.path, from: authoring.path)
          .split(path.separator)
          .join('/');
      _require(
        name.length <= 240 &&
            names.add(name.toLowerCase()) &&
            names.length <= 100000,
      );
      if (entry is File) {
        files[name] = entry;
      } else if (entry is Directory) {
        final parts = name.split('/');
        _require(parts[0] == 'v1' && parts.length <= 4);
        if (parts.length > 1) _enum(parts[1], ['drafts', 'deleted', 'applied']);
        if (parts.length >= 3) _draftId(parts[2]);
        if (parts.length == 3) {
          _require(ids.add(parts[2]));
          folders.add(name);
        }
        if (parts.length == 4) _enum(parts[3], ['media', 'history']);
      } else {
        throw const FormatException('Authoring symlink or special file');
      }
    }
    final accepted = <String>{};
    for (final folder in folders) {
      final currentName = '$folder/manifest.json';
      final current = await _record(files[currentName]);
      final manifest = current.manifest;
      _require(manifest['id'] == folder.split('/').last);
      records[folder] = current;
      accepted.add(currentName);
      if (folder.startsWith('v1/drafts/') && manifest['targetId'] != null) {
        _require(targets.add('${manifest['kind']}:${manifest['targetId']}'));
      }
      if (folder.startsWith('v1/applied/')) {
        final name = '$folder/receipt.json';
        final receipt = await _json(files[name], 8192);
        _fields(receipt, {
          'schemaVersion': _version,
          'draftId': _draftId,
          'kind': _kind,
          'revision': _revision,
          'targetId': _contentId,
          'resultFingerprint': _digest,
          'appliedAt': _date,
        });
        for (final key in [
          'schemaVersion',
          'draftId',
          'kind',
          'revision',
          'targetId',
          'resultFingerprint',
          'appliedAt',
        ]) {
          _require(receipt[key] != null);
        }
        _require(
          receipt['draftId'] == manifest['id'] &&
              receipt['kind'] == manifest['kind'] &&
              receipt['revision'] == manifest['revision'] &&
              (manifest['targetId'] == null ||
                  receipt['targetId'] == manifest['targetId']),
        );
        accepted.add(name);
      }
      final revisions = [current];
      for (
        var revision = 1;
        revision < (manifest['revision'] as int);
        revision++
      ) {
        final name = '$folder/history/$revision.json';
        final previous = await _record(files[name]);
        for (final key in [
          'id',
          'kind',
          'targetId',
          'baseFingerprint',
          'createdAt',
        ]) {
          _require(previous.manifest[key] == manifest[key]);
        }
        _require(
          previous.manifest['revision'] == revision &&
              !DateTime.parse(previous.manifest['savedAt'] as String)
                  .isAfter(DateTime.parse(manifest['savedAt'] as String)),
        );
        revisions.add(previous);
        accepted.add(name);
      }
      for (final revision in revisions) {
        for (final media in revision.media) {
          final file = files['$folder/${media['path']}'];
          _require(file != null && await file.length() == media['byteLength']);
        }
      }
      for (final entry in files.entries.where(
        (entry) => entry.key.startsWith('$folder/media/'),
      )) {
        final name = path.posix.basename(entry.key);
        _require(RegExp(r'^[0-9a-f]{64}\.[a-z0-9]{1,10}$').hasMatch(name));
        _require(
          await entry.value.length() > 0 &&
              (await sha256.bind(entry.value.openRead()).first).toString() ==
                  name.split('.').first,
        );
        accepted.add(entry.key);
      }
    }
    _require(files.keys.every(accepted.contains));
    final people = (jsonDecode(
      await File(path.join(root.path, 'data/4/people/list.json'))
          .readAsString(),
    ) as List).map((person) => (person as Map)['id']).toSet();
    for (final entry in records.entries.where(
      (entry) => entry.key.startsWith('v1/drafts/'),
    )) {
      for (final reference in entry.value.refs) {
        if (reference['kind'] == 'ready') {
          _require(people.contains(reference['contentId']));
        } else {
          final id = reference['draftId'];
          final person = records['v1/drafts/$id'] ?? records['v1/applied/$id'];
          _require(person != null && person.manifest['kind'] == 'person');
        }
      }
    }
  }

  Future<
    ({
      Map<String, dynamic> manifest,
      List<Map<String, dynamic>> media,
      List<Map<String, dynamic>> refs,
    })
  >
  _record(File? file) async {
    final record = await _json(file, 8 * 1024 * 1024);
    _require(
      record.keys.toSet().containsAll(['manifest', 'payload']) &&
          record.length == 2,
    );
    final manifest = record['manifest'] as Map<String, dynamic>;
    _fields(manifest, {
      'schemaVersion': _version,
      'id': _draftId,
      'kind': _kind,
      'revision': _revision,
      'createdAt': _date,
      'savedAt': _date,
      'targetId': _contentId,
      'baseFingerprint': _digest,
    });
    for (final key in [
      'schemaVersion',
      'id',
      'kind',
      'revision',
      'createdAt',
      'savedAt',
    ]) {
      _require(manifest[key] != null);
    }
    _require(
      (manifest['targetId'] == null) == (manifest['baseFingerprint'] == null),
    );
    _require(
      !DateTime.parse(manifest['savedAt'] as String)
          .isBefore(DateTime.parse(manifest['createdAt'] as String)),
    );
    final media = <Map<String, dynamic>>[];
    final refs = <Map<String, dynamic>>[];
    void mediaFile(Object value) {
      final data = value as Map<String, dynamic>;
      _fields(data, {
        'path': _string,
        'byteLength': _integer,
        'sha256': _digest,
      });
      _require(
        data['byteLength'] is int &&
            (data['byteLength'] as int) > 0 &&
            data['sha256'] != null,
      );
      _require(
        data['path'] is String &&
            RegExp('^media/${data['sha256']}\\.[a-z0-9]{1,10}\$')
                .hasMatch(data['path'] as String),
      );
      media.add(data);
    }

    void pair(Object value) => _fields(value as Map<String, dynamic>, {
      'original': mediaFile,
      'thumbnail': mediaFile,
    });
    void reference(Object value) {
      final data = value as Map<String, dynamic>;
      _fields(data, {
        'kind': (value) => _enum(value, ['ready', 'draft']),
        'contentId': _contentId,
        'draftId': _draftId,
      });
      _require(
        data['kind'] == 'ready'
            ? data['contentId'] != null && data['draftId'] == null
            : data['kind'] == 'draft' &&
                  data['draftId'] != null &&
                  data['contentId'] == null,
      );
      refs.add(data);
    }

    final common = <String, void Function(Object)>{
      'name': _string,
      'createDate': _date,
      'updateDate': _date,
    };
    final payload = record['payload'] as Map<String, dynamic>;
    if (manifest['kind'] == 'person') {
      _fields(payload, {
        ...common,
        'surname': _string,
        'gender': (value) =>
            _enum(value, PersonGenderDto.values.map((item) => item.name)),
        'url': _string,
        'info': _string,
        'roles': (value) => _list(
          value,
          (role) => _enum(role, PersonRoleDto.values.map((item) => item.name)),
        ),
        'photo': pair,
      });
    } else {
      _fields(payload, {
        ...common,
        'summary': _string,
        'tags': (value) => _list(
          value,
          (tag) => _enum(tag, TaleTag.values.map((item) => item.name)),
        ),
        'text': (value) => _fields(value as Map<String, dynamic>, {
          'minReadingTime': _integer,
          'maxReadingTime': _integer,
          'items': (value) => _list(value, (item) {
            final data = item as Map<String, dynamic>;
            _fields(data, {
              'kind': (value) => _enum(value, ['text', 'image']),
              'text': _string,
              'imageIndex': _integer,
            });
            _require(
              data['kind'] == 'text'
                  ? data['imageIndex'] == null
                  : data['kind'] == 'image' && data['text'] == null,
            );
          }),
        }),
        'audio': (value) => _fields(value as Map<String, dynamic>, {
          'fileSize': _integer,
          'duration': _integer,
          'files': pair,
        }),
        'images': (value) => _list(
          value,
          (item) => _fields(item as Map<String, dynamic>, {
            'index': _integer,
            'files': pair,
          }),
        ),
        'adminConfig': (value) => _fields(value as Map<String, dynamic>, {
          'isHidden': _boolean,
          'isReviewed': _boolean,
          'comment': _string,
        }),
        'crew': (value) => _fields(value as Map<String, dynamic>, {
          for (final role in PersonRoleDto.values)
            role.name: (value) => _list(value, reference),
        }),
      });
    }
    return (manifest: manifest, media: media, refs: refs);
  }

  Future<Map<String, dynamic>> _json(File? file, int maxLength) async {
    _require(file != null && await file.length() <= maxLength);
    return jsonDecode(await file!.readAsString()) as Map<String, dynamic>;
  }

  void _fields(
    Map<String, dynamic> data,
    Map<String, void Function(Object)> fields,
  ) {
    for (final entry in data.entries) {
      _require(fields.containsKey(entry.key));
      if (entry.value != null) fields[entry.key]!(entry.value as Object);
    }
  }

  void _list(Object value, void Function(Object) check) {
    for (final item in value as List) {
      check(item as Object);
    }
  }

  void _enum(Object value, Iterable<String> values) =>
      _require(value is String && values.contains(value));
  void _string(Object value) => _require(value is String);
  void _boolean(Object value) => _require(value is bool);
  void _integer(Object value) => _require(value is int);
  void _date(Object value) =>
      _require(value is String && DateTime.tryParse(value) != null);
  void _kind(Object value) => _enum(value, ['person', 'tale']);
  void _version(Object value) => _require(value is int && value == 1);
  void _revision(Object value) =>
      _require(value is int && value >= 1 && value <= 100000);
  void _contentId(Object value) => _require(
    value is int &&
        value >= 0 &&
        value != TaleDto.stubId &&
        value <= 9007199254740991,
  );
  void _draftId(Object value) =>
      _require(value is String && RegExp(r'^[0-9a-f]{32}$').hasMatch(value));
  void _digest(Object value) =>
      _require(value is String && RegExp(r'^[0-9a-f]{64}$').hasMatch(value));
  void _require(bool condition) {
    if (!condition)
      throw const FormatException('Invalid authoring/v1 structure');
  }
}
