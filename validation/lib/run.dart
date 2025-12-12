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

    final audio = files.where((file) {
      final name = file.path.split('/').last;
      return !name.contains('original.');
    }).first;

    final bytes = audio.readAsBytesSync();

    final audioName = audio.path.split('/').last;
    final format = audioName.split('.').last;
    if (format != 'mp3') {
      throw Exception('Unexpected format: $format');
    }
    final newName = audioName.replaceFirst(audioName, 'thumbnail.mp3');

    final newFile = File('${audioDir.path}/$newName');

    newFile.createSync();
    newFile.writeAsBytesSync(bytes);

    audio.deleteSync();
  }
}
