import 'dart:io';

void main() {
  final dir = Directory(
    '/Users/andrii.antonov/dev/kazky/content/data/4/tales/',
  );

  final children = dir.listSync().whereType<Directory>().toList();

  for (final dir in children) {
    final id = dir.path.split('/').last;
    print('Processing $id');
    if (id == '0') {
      id.toString();
    }
    final audioDir = Directory('${dir.path}/audio/');
    if (!audioDir.existsSync()) continue;

    final files = audioDir.listSync().whereType<File>().toList();

    final original = files.where((file) {
      final name = file.path.split('/').last;
      return !name.contains('audio.mp3');
    }).firstOrNull;

    final thumbnail = files.where((file) {
      final name = file.path.split('/').last;
      return name.contains('audio.mp3');
    }).first;

    if (original == null) {
      final bytes = thumbnail.readAsBytesSync();

      final thumbnailName = thumbnail.path.split('/').last;
      final newName = thumbnailName.replaceFirst('audio.mp3', 'original.mp3');

      final newFile = File('${audioDir.path}/$newName');
      newFile.createSync();
      newFile.writeAsBytesSync(bytes);
    }
  }
}
