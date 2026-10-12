import 'dart:io';

import 'package:validation/people_layout.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length > 1) {
    stderr.writeln(
      'Usage: dart run bin/migrate_people_split.dart [content-root]',
    );
    exitCode = 64;
    return;
  }
  final root = arguments.isEmpty
      ? Directory.current.parent
      : Directory(arguments.single).absolute;
  try {
    final migrated = await splitPeople(root);
    print(
      migrated
          ? 'Split people/list.json into person.json files + index.json. '
              'Run bin/validate_data_4.dart before committing.'
          : 'People are already split; nothing to do.',
    );
  } on FormatException catch (error) {
    stderr.writeln('Migration refused: ${error.message}');
    exitCode = 1;
  }
}
