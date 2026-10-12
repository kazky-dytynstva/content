import 'dart:io';

import 'package:validation/media_manifest.dart';

/// Regenerates `media.json` for every person and tale after media changes.
Future<void> main(List<String> arguments) async {
  if (arguments.length > 1) {
    stderr.writeln(
      'Usage: dart run bin/write_media_manifests.dart [content-root]',
    );
    exitCode = 64;
    return;
  }
  final root = arguments.isEmpty
      ? Directory.current.parent
      : Directory(arguments.single).absolute;
  final written = await writeMediaManifests(root);
  print(
    written == 0
        ? 'All media manifests are up to date.'
        : 'Wrote $written media.json file(s). Run bin/validate_data_4.dart '
            'before committing.',
  );
}
