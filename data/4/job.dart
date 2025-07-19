import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  final file = File(
    '/Users/andrii.antonov/dev/kazky/content/data/4/tales/list.json',
  );

  final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;

  var summaryMin = 10000;
  var summaryMax = 0;
  var minName = '';

  for (final item in jsonList) {
    final name = item['name'] as String;

    final summaryLength = name.length;

    if (summaryLength < summaryMin) {
      summaryMin = summaryLength;
      minName = name;
    }
    if (summaryLength > summaryMax) {
      summaryMax = summaryLength;
    }
  }

  print('name min: $summaryMin, name: $minName');
  print('name max: $summaryMax');
}
