import 'dart:convert';
import 'dart:io';

void main() {
  final path = Directory(
    '/Users/andrii.antonov/dev/kazky/content/data/3/people/img/',
  );

  final files = path.listSync().whereType<File>().toList();

  files.sort((a, b) {
    final aId = int.parse(a.path.split('/').last.split('.').first);
    final bId = int.parse(b.path.split('/').last.split('.').first);

    return bId.compareTo(aId);
  });

  for (final file in files) {
    final filePath = file.path;
    final fileName = filePath.split('/').last;
    final id = int.parse(fileName.split('.').first);

    if (id < 35) continue;

    final incrementedId = id + 1;

    final newFileName = fileName.replaceFirst('$id.', '$incrementedId.');
    final newPath = filePath.replaceFirst('$fileName.', '$newFileName.');

    if (id == 35) {
      file.copySync(newPath);
    } else {
      file.renameSync(newPath);
    }
  }
}
//   final path =
//       File('/Users/andrii.antonov/dev/kazky/content/data/2/people/list.json');

//   final content = path.readAsStringSync();

//   final jsonContent = jsonDecode(content) as List<dynamic>;

//   jsonContent.sort((a, b) {
//     final aId = a['id'] as int;
//     final bId = b['id'] as int;

//     return aId.compareTo(bId);
//   });

//   final result = <Map<String, dynamic>>[];

//   var correction = 0;

//   for (var item in jsonContent) {
//     final person = item as Map<String, dynamic>;

//     final id = person['id'] as int;

//     if (id > 35) {
//       correction = 1;
//     }

//     final int correctId = id + correction;

//     final updatedPerson = {
//       'id': correctId,
//       'name': person['name'],
//       'surname': person['surname'],
//       'gender': person['gender'],
//       'url': person['url'],
//       'info': person['info'],
//       'roles': person['roles'],
//     };

//     result.add(updatedPerson);

//     if (id == 35) {
//       final updatedPerson = {
//         'id': correctId + 1,
//         'name': person['name'] + ' БРО',
//         'surname': person['surname'],
//         'gender': person['gender'],
//         'url': person['url'],
//         'info': person['info'],
//         'roles': person['roles'],
//       };
//       result.add(updatedPerson);
//     }
//   }

//   result.sort((a, b) {
//     final aId = a['id'] as int;
//     final bId = b['id'] as int;

//     return bId.compareTo(aId);
//   });

//   final updatedContent = jsonEncode(result);

//   path.writeAsStringSync(updatedContent);
// }
