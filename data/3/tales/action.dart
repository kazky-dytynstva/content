import 'dart:convert';
import 'dart:io';

// import 'add_tale_reading_time.dart';

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

  final file = File(
    '/Users/andrii.antonov/dev/kazky/content/data/3/tales/summary.csv',
  );
  final content = file.readAsStringSync();

  final lines = content.split('\n');

  final summaryContetn = <int, String>{};

  for (final line in lines) {
    final taleId = line.split(',')[0];
    final value = line.substring(taleId.length + 2, line.length - 1);

    summaryContetn[int.parse(taleId)] = value;
  }

  final jsonFile = File(
    '/Users/andrii.antonov/dev/kazky/content/data/3/tales/list.json',
  );

  final jsonContentString = jsonFile.readAsStringSync();
  final jsonContent = jsonDecode(jsonContentString);

  for (final tale in jsonContent) {
    final taleId = tale['id'];
    var summary = summaryContetn[taleId]!;

    if (summary.contains('""')) {
      summary = summary.replaceAll('""', '"');
    }

    if (summary.length < 140 || summary.length > 200) {
      print('Tale $taleId has wrong summary length: ${summary.length}');
    }

    tale['summary'] = summary;

    tale.toString();
  }

  final updatedJsonContentString = jsonEncode(jsonContent);
  jsonFile.writeAsStringSync(updatedJsonContentString);
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
