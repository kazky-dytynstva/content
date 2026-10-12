import 'dart:convert';
import 'dart:io';

import 'package:dto/dto.dart';
import 'package:path/path.dart' as path;

import 'ready_content.dart';

const _encoder = JsonEncoder.withIndent('  ');

/// The people catalogue of [root]: `index.json` (split layout) or the legacy
/// `list.json`.
File readyPeopleListFile(Directory root) {
  final index = File(path.join(root.path, 'data', '4', 'people', 'index.json'));
  return index.existsSync()
      ? index
      : File(path.join(root.path, 'data', '4', 'people', 'list.json'));
}

/// Migrates `data/4/people/list.json` into `people/{id}/person.json` files plus
/// `people/index.json`, keeping `list.json.gz` untouched. Returns `false` when
/// the content is already split.
Future<bool> splitPeople(Directory root) async {
  final people = Directory(path.join(root.path, 'data', '4', 'people'));
  final list = File(path.join(people.path, 'list.json'));
  final index = File(path.join(people.path, 'index.json'));
  if (!await list.exists()) {
    if (await index.exists()) return false;
    throw const FormatException('Missing people/list.json');
  }
  if (await index.exists()) {
    throw const FormatException('Both people/list.json and index.json exist');
  }

  final records = (jsonDecode(await list.readAsString()) as List)
      .cast<Map<String, dynamic>>();
  final ids = <int>{};
  for (final record in records) {
    final id = record['id'];
    if (id is! int || id < 0 || !ids.add(id)) {
      throw const FormatException('Invalid or duplicate person ID');
    }
  }
  records.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));

  final production = jsonDecode(
    utf8.decode(
      gzip.decode(
        await File(path.join(people.path, 'list.json.gz')).readAsBytes(),
      ),
    ),
  );
  if (canonical(production) !=
      canonical(
        records.map((r) => PersonDto.fromJson(r).toProdJson()).toList(),
      )) {
    throw const FormatException('people/list.json.gz does not match list.json');
  }

  for (final record in records) {
    final folder = Directory(path.join(people.path, '${record['id']}'));
    final file = File(path.join(folder.path, 'person.json'));
    if (await file.exists()) {
      throw FormatException('Already exists: ${file.path}');
    }
    await folder.create();
    await file.writeAsString(_encoder.convert(record));
  }
  await index.writeAsString(_encoder.convert(records));
  await list.delete();
  return true;
}
