import 'dart:convert';
import 'dart:io';

Set<int> collidingIds(Set<int> ancestor, Set<int> base, Set<int> head) =>
    head.difference(ancestor).intersection(base);

Future<void> validateBranchIds(
  Directory repository,
  String ancestor,
  String base,
  String head,
) async {
  for (final revision in [ancestor, base, head]) {
    if (!RegExp(r'^[0-9a-f]{40}(?:[0-9a-f]{24})?$').hasMatch(revision))
      throw const FormatException('Expected immutable Git revision');
  }
  Future<String> git(List<String> arguments) async {
    final result = await Process.run(
      'git',
      arguments,
      workingDirectory: repository.path,
    );
    if (result.exitCode != 0)
      throw const FormatException('Cannot read branch ID evidence');
    return result.stdout as String;
  }

  Future<Set<int>> ids(String revision, String kind) async {
    final records = jsonDecode(
      await git(['show', '$revision:data/4/$kind/list.json']),
    ) as List;
    final result = <int>{};
    for (final record in records) {
      final id = (record as Map)['id'];
      if (id is! int || id < 0 || !result.add(id))
        throw const FormatException('Invalid branch ID collection');
    }
    return result;
  }

  final baseReservations = <String, Set<int>>{'people': {}, 'tales': {}};
  final receipts = const LineSplitter().convert(
    await git([
      'ls-tree',
      '-r',
      '--name-only',
      base,
      '--',
      'authoring/v1/applied',
    ]),
  );
  for (final file in receipts.where((name) => name.endsWith('/receipt.json'))) {
    if (!RegExp(r'^authoring/v1/applied/[0-9a-f]{32}/receipt\.json$')
        .hasMatch(file))
      throw const FormatException('Invalid receipt path');
    final receipt = jsonDecode(await git(['show', '$base:$file'])) as Map;
    final target = receipt['targetId'];
    final kind = switch (receipt['kind']) {
      'person' => 'people',
      'tale' => 'tales',
      _ => throw const FormatException('Invalid receipt kind'),
    };
    if (receipt['schemaVersion'] != 1 || target is! int || target < 0)
      throw const FormatException('Invalid receipt target');
    baseReservations[kind]!.add(target);
  }
  for (final kind in ['people', 'tales']) {
    final original = await ids(ancestor, kind);
    final target = await ids(base, kind);
    final proposed = await ids(head, kind);
    final collisions = collidingIds(original, {
      ...target,
      ...baseReservations[kind]!,
    }, proposed);
    if (collisions.isNotEmpty)
      throw FormatException(
        'Independent $kind ID allocation collision: $collisions',
      );
  }
}
