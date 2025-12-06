import 'dart:io';

void main() {
  final dir = Directory('/Users/andrii.antonov/dev/kazky/content/data/4/tales');

  final talesDirs = dir.listSync().whereType<Directory>().toList();

  for (final taleDir in talesDirs) {
    final imgDir = Directory('${taleDir.path}/img');
    final files = imgDir.listSync().whereType<File>().toList();

    if (files.length > 1) continue;

    final fileName = files.first.path.split('/').last;
    assert(
      fileName == '0.thumbnail.jpg',
      'Unexpected file name: $fileName in ${imgDir.path}',
    );

    final content = files.first.readAsBytesSync();
    final newFile = File(
      '${taleDir.path}/${fileName.replaceAll('thumbnail', 'original')}',
    );
    newFile.createSync(recursive: true);
    newFile.writeAsBytesSync(content);
    print('Fixed: ${newFile.path}');
  }

  print('Done');
}
