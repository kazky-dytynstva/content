import 'dart:io';

void main() {
  final dir = Directory('/Users/andrii.antonov/dev/kazky/content/data/4/tales');

  final talesDirs = dir.listSync().whereType<Directory>().toList();

  for (final taleDir in talesDirs) {
    final audioDir = Directory('${taleDir.path}/audio');
    if (!audioDir.existsSync()) continue;

    final files = audioDir.listSync().whereType<File>().toList();
    if (files.isEmpty) {
      audioDir.deleteSync();
      print('Deleted empty audio dir: ${audioDir.path}');
    }
  }

  print('Done');
}
