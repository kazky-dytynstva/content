import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

/// The `tales/index.json` entry of a full tale record: everything but `text`.
Map<String, dynamic> taleIndexEntry(Map<String, dynamic> tale) => {
      for (final entry in tale.entries)
        if (entry.key != 'text') entry.key: entry.value,
    };

/// The derived tales catalogue of [root] (`data/4/tales/index.json`).
File readyTalesListFile(Directory root) =>
    File(path.join(root.path, 'data', '4', 'tales', 'index.json'));

/// Full tale records of [root]: every `tales/{id}/tale.json`, sorted by ID
/// descending.
Future<List<Map<String, dynamic>>> readyTaleRecords(Directory root) async {
  final tales = Directory(path.join(root.path, 'data', '4', 'tales'));
  final records = <Map<String, dynamic>>[];
  await for (final entry in tales.list(followLinks: false)) {
    final file = File(path.join(entry.path, 'tale.json'));
    if (entry is Directory && await file.exists()) {
      records
          .add(jsonDecode(await file.readAsString()) as Map<String, dynamic>);
    }
  }
  return records..sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
}
