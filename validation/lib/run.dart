import 'dart:convert';
import 'dart:io';

void main() {
  final file = File(
    '/Users/andrii.antonov/dev/kazky/content/data/4/tales/list.json',
  );
  final stringContent = file.readAsStringSync();

  final list = jsonDecode(stringContent) as List<dynamic>;

  for (final item in list) {
    final text = item['text'] as Map<String, dynamic>?;
    if (text == null) continue;

    final paragraphs = text.remove('paragraphs');
    text['items'] = paragraphs;
  }

  final updatedContent = jsonEncode(list);

  file.writeAsStringSync(updatedContent);
}
