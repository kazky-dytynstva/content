import 'dart:convert';
import 'dart:io';

import 'add_tale_reading_time.dart';

// void copyContents(Directory taleDir) {
//   final zeroDir = Directory(taleDir.path + '/0');

//   // copy audio
//   for (final entity in zeroDir.listSync()) {
//     if (entity is! File) {
//       continue;
//     }

//     String newPath = '${taleDir.path}/${entity.uri.pathSegments.last}';
//     entity.copySync(newPath);
//   }

//   final newImageDir = Directory(taleDir.path + '/img');
//   newImageDir.createSync();

//   final zeroImgDir = Directory(zeroDir.path + '/img');

//   // copy images
//   for (final entity in zeroImgDir.listSync()) {
//     if (entity is! File) {
//       continue;
//     }

//     String newPath = '${newImageDir.path}/${entity.uri.pathSegments.last}';
//     entity.copySync(newPath);
//   }

//   zeroDir.deleteSync(recursive: true);
// }

void main() {
  // final dir = Directory(
  //   '/Users/andrii.antonov/dev/kazky/content/data/3/tales/',
  // );

  // final files = dir.listSync();

  // for (final entity in files) {
  //   if (entity is! Directory) {
  //     continue;
  //   }

  //   copyContents(entity);
  // }

  final file =
      File('/Users/andrii.antonov/dev/kazky/content/data/3/tales/list.json');
  final content = file.readAsStringSync();
  final jsonContent = jsonDecode(content) as List<dynamic>;

  final addTaleReadingTime = AddTaleReadingTime();

  for (final item in jsonContent) {
    item as Map<String, dynamic>;

    final text = item['text'] as Map<String, dynamic>?;

    if (text == null) {
      continue;
    }

    if (text['text'] == null) {
      continue;
    }

    final paragraphs = (text['text'] as List).map((e) => e as String).toList();

    text.remove('text');
    text['paragraphs'] = paragraphs;

    final readingTime =
        addTaleReadingTime.getReadingTime(paragraphs: paragraphs);

    text['min_reading_time'] = readingTime.minimum;
    text['max_reading_time'] = readingTime.maximum;
  }

  file.writeAsStringSync(jsonEncode(jsonContent));

  // final newFile =
  //     File('/Users/andrii.antonov/dev/kazky/content/data/3/tales/action.json');
  // newFile.writeAsStringSync(jsonEncode(result));

  // // Convert JSON to CSV
  // String csvData = jsonToCsv(result);

  // // // Print or save the CSV data
  // // print(csvData);

  // // Example: Save to a file
  // File('/Users/andrii.antonov/dev/kazky/content/data/3/tales/output.csv')
  //     .writeAsString(csvData);
}

String jsonToCsv(Map<String, dynamic> jsonData) {
  List<List<String>> rows = [];

  jsonData.forEach((key, value) {
    rows.add([key, value.toString()]);
  });

  // Create CSV string
  String csv = ListToCsvConverter().convert(rows);

  return csv;
}

class ListToCsvConverter {
  String convert(List<List<String>> data, {String separator = ','}) {
    String csv = '';
    for (var row in data) {
      csv += row.join(separator) + '\n';
    }
    return csv;
  }
}
