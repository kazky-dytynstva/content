import 'dart:io';

import 'package:path/path.dart' as path;

import 'validate_data_4.dart';

class MobileDelivery {
  Future<void> build(Directory root, Directory output) async {
    final source = await root.resolveSymbolicLinks();
    final parent = await output.parent.resolveSymbolicLinks();
    final destination = path.join(parent, path.basename(output.path));
    if (path.equals(source, destination) ||
        path.isWithin(source, destination) ||
        path.isWithin(destination, source) ||
        await FileSystemEntity.type(output.path, followLinks: false) !=
            FileSystemEntityType.notFound) {
      throw const FormatException(
        'Delivery must use a new directory outside the content checkout',
      );
    }
    final validation = await Data4Validator(source).validate();
    if (!validation.success)
      throw FormatException(validation.errors.join('\n'));
    final allowlist = RegExp(
      r'^data/4/(?:people/list\.json\.gz|tales/list\.json\.gz|people/(?:0|[1-9][0-9]*)/photo\.thumbnail\.jpg|tales/(?:0|[1-9][0-9]*)/(?:img/(?:0|[1-9][0-9]*)\.thumbnail\.jpg|audio/thumbnail\.m4a))$',
    );
    await Directory(destination).create();
    await for (final entry in Directory(
      path.join(source, 'data/4'),
    ).list(recursive: true, followLinks: false)) {
      final relative = path
          .relative(entry.path, from: source)
          .split(path.separator)
          .join('/');
      if (entry is! File || !allowlist.hasMatch(relative)) continue;
      final target = File(path.join(destination, relative));
      await target.parent.create(recursive: true);
      await entry.copy(target.path);
    }
  }
}
