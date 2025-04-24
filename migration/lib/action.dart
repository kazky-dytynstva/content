import 'dart:io';

void main() async {
  final dir = Directory('/Users/andrii.antonov/dev/kazky/content/data/3/tales');

  final nestedDirs = dir.listSync().whereType<Directory>();

  for (final dir in nestedDirs) {
    final zeroDir = Directory('${dir.path}/0');

    await copyDirectory(zeroDir, dir);

    await zeroDir.delete(recursive: true);
  }
}

Future<void> copyDirectory(Directory source, Directory destination) async {
  if (!await destination.exists()) {
    await destination.create(recursive: true);
  }

  await for (var entity in source.list(recursive: false)) {
    var newPath = '${destination.path}/${entity.uri.pathSegments.last}';

    if (entity is File) {
      await entity.copy(newPath);
    } else if (entity is Directory) {
      await copyDirectory(entity, Directory(newPath));
    }
  }
}
