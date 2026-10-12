import 'dart:convert';
import 'dart:io';

import 'package:dto/dto.dart';
import 'package:path/path.dart' as path;

import 'ready_content.dart';

const _encoder = JsonEncoder.withIndent('  ');

/// The `tales/index.json` entry of a full tale record: everything but `text`.
Map<String, dynamic> taleIndexEntry(Map<String, dynamic> tale) => {
      for (final entry in tale.entries)
        if (entry.key != 'text') entry.key: entry.value,
    };

/// The tales catalogue of [root]: `index.json` (split layout) or the legacy
/// `list.json`.
File readyTalesListFile(Directory root) {
  final index = File(path.join(root.path, 'data', '4', 'tales', 'index.json'));
  return index.existsSync()
      ? index
      : File(path.join(root.path, 'data', '4', 'tales', 'list.json'));
}

/// Full tale records of [root]: the legacy `tales/list.json`, or every
/// `tales/{id}/tale.json` sorted by ID descending.
Future<List<Map<String, dynamic>>> readyTaleRecords(Directory root) async {
  final tales = Directory(path.join(root.path, 'data', '4', 'tales'));
  final list = File(path.join(tales.path, 'list.json'));
  if (await list.exists()) {
    return (jsonDecode(await list.readAsString()) as List)
        .cast<Map<String, dynamic>>();
  }
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

/// Migrates `data/4/tales/list.json` into `tales/{id}/tale.json` files plus a
/// text-less `tales/index.json`, keeping `list.json.gz` untouched. Returns
/// `false` when the content is already split.
Future<bool> splitTales(Directory root) async {
  final tales = Directory(path.join(root.path, 'data', '4', 'tales'));
  final list = File(path.join(tales.path, 'list.json'));
  final index = File(path.join(tales.path, 'index.json'));
  if (!await list.exists()) {
    if (await index.exists()) return false;
    throw const FormatException('Missing tales/list.json');
  }
  if (await index.exists()) {
    throw const FormatException('Both tales/list.json and index.json exist');
  }

  final records = (jsonDecode(await list.readAsString()) as List)
      .cast<Map<String, dynamic>>();
  final ids = <int>{};
  for (final record in records) {
    final id = record['id'];
    if (id is! int || id < 0 || !ids.add(id)) {
      throw const FormatException('Invalid or duplicate tale ID');
    }
  }
  records.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));

  final production = jsonDecode(
    utf8.decode(
      gzip.decode(
        await File(path.join(tales.path, 'list.json.gz')).readAsBytes(),
      ),
    ),
  );
  if (canonical(production) !=
      canonical(
        records.map((r) => TaleDto.fromJson(r).toProdJson()).toList(),
      )) {
    throw const FormatException('tales/list.json.gz does not match list.json');
  }

  for (final record in records) {
    final file = File(path.join(tales.path, '${record['id']}', 'tale.json'));
    if (await file.exists()) {
      throw FormatException('Already exists: ${file.path}');
    }
    await file.parent.create();
    await file.writeAsString(_encoder.convert(record));
  }
  await index.writeAsString(
    _encoder.convert(records.map(taleIndexEntry).toList()),
  );
  await list.delete();
  return true;
}
