import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

/// Per-item manifest of every media file next to `person.json`/`tale.json`.
const mediaManifestName = 'media.json';

const _notMedia = {'person.json', 'tale.json', mediaManifestName};

/// The git object id of a blob with [bytes] content.
String gitBlobSha(List<int> bytes) => sha1.convert(
    [...utf8.encode('blob ${bytes.length}\u0000'), ...bytes]).toString();

/// The `media.json` content describing the files under item folder [item]:
/// `{"files": [{"path", "sha", "bytes"}]}` sorted by path.
Future<Map<String, Object>> buildMediaManifest(Directory item) async {
  final files = <Map<String, Object>>[];
  await for (final entry in item.list(recursive: true, followLinks: false)) {
    if (entry is! File) continue;
    final relative = path
        .relative(entry.path, from: item.path)
        .split(path.separator)
        .join('/');
    if (_notMedia.contains(relative)) continue;
    final bytes = await entry.readAsBytes();
    files.add({
      'path': relative,
      'sha': gitBlobSha(bytes),
      'bytes': bytes.length,
    });
  }
  files.sort((a, b) => (a['path'] as String).compareTo(b['path'] as String));
  return {'files': files};
}

/// Writes `media.json` for every person and tale folder of [root] whose
/// manifest is missing or stale. Returns the number of files written.
Future<int> writeMediaManifests(Directory root) async {
  var written = 0;
  for (final kind in ['people', 'tales']) {
    final folder = Directory(path.join(root.path, 'data', '4', kind));
    await for (final entry in folder.list(followLinks: false)) {
      if (entry is! Directory ||
          !RegExp(r'^(0|[1-9][0-9]*)$').hasMatch(path.basename(entry.path))) {
        continue;
      }
      final file = File(path.join(entry.path, mediaManifestName));
      final content = const JsonEncoder.withIndent(
        '  ',
      ).convert(await buildMediaManifest(entry));
      if (await file.exists() && await file.readAsString() == content) {
        continue;
      }
      await file.writeAsString(content);
      written++;
    }
  }
  return written;
}
