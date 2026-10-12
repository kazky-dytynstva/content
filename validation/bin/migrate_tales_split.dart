import 'dart:io';

import 'package:validation/tales_layout.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length > 1) {
    stderr
        .writeln('Usage: dart run bin/migrate_tales_split.dart [content-root]');
    exitCode = 64;
    return;
  }
  final root = arguments.isEmpty
      ? Directory.current.parent
      : Directory(arguments.single).absolute;
  try {
    final migrated = await splitTales(root);
    print(
      migrated
          ? 'Split tales/list.json into tale.json files + index.json. '
              'Run bin/validate_data_4.dart before committing.'
          : 'Tales are already split; nothing to do.',
    );
  } on FormatException catch (error) {
    stderr.writeln('Migration refused: ${error.message}');
    exitCode = 1;
  }
}
