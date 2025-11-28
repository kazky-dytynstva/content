import 'dart:convert';
import 'dart:io';

void main() {
  final peopleDir = Directory(
    '/Users/andrii.antonov/dev/kazky/content/data/4/people/',
  );

  final jsonFile = File('${peopleDir.path}list.json');

  final jsonList = jsonDecode(jsonFile.readAsStringSync()) as List<dynamic>;

  final now = DateTime.now();

  final people = jsonList.map((e) {
    final map = {
      'id': e['id'],
      'name': e['name'],
      'surname': e['surname']!.toString().trim(),
      'gender': e['gender'],
    };
    final url = e['url'];
    if (url != null) {
      map['url'] = url;
    }
    final info = e['info'];
    if (info != null) {
      map['info'] = info;
    }
    final roles = e['roles'];
    if (roles != null) {
      map['roles'] = roles;
    }
    map['create_date'] = now.toIso8601String();
    return map;
  }).toList();

  final updatedJson = jsonEncode(people);
  jsonFile.writeAsStringSync(updatedJson);

  // final dirs = Directory('${peopleDir.path}')
  //     .listSync()
  //     .where((e) {
  //       final fileName = e.path.split('/').last;
  //       return int.tryParse(fileName) != null;
  //     })
  //     .cast<Directory>()
  //     .toList();

  // for (final dir in dirs) {
  //   final files = dir.listSync().whereType<File>().toList();
  //   if (files.length == 2) continue;

  //   final first = files.first;

  //   final fileName = first.path.split('/').last;
  //   final originalFileName = fileName.replaceAll('thumbnail', 'original');
  //   final originalFile = File('${dir.path}/$originalFileName');
  //   first.copySync(originalFile.path);
  // }

  // // files.sort((a, b) {
  // //   final aId = int.parse(a.path.split('/').last.split('.').first);
  // //   final bId = int.parse(b.path.split('/').last.split('.').first);

  // //   return bId.compareTo(aId);
  // // });

  // for (final file in files) {
  //   try {
  //     final fileName = file.path.split('/').last;
  //     final format = fileName.split('.').last;
  //     final personId = int.parse(fileName.split('.').first);
  //     late final String newPath;
  //     if (fileName.contains('original')) {
  //       newPath = '${peopleDir.path}$personId/photo.original.$format';
  //     } else {
  //       newPath = '${peopleDir.path}$personId/photo.thumbnail.$format';
  //     }
  //     final newFile = File(newPath);
  //     if (!newFile.existsSync()) {
  //       newFile.createSync(recursive: true);
  //     }
  //     file.copySync(newFile.path);
  //     print('Copied ${file.path} to ${newFile.path}');
  //   } catch (e) {
  //     print('Error processing file ${file.path}: $e');
  //   }
  // }

  print('All files processed successfully.');
}
