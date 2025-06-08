import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('/Users/andrii.antonov/dev/kazky/content/data/4/job.json');

  final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;

  for (final item in jsonList) {
    final createDate = item['create_date'] as int;
    final updateDate = item['update_date'] as int?;

    item['create_date'] =
        DateTime.fromMillisecondsSinceEpoch(createDate).toIso8601String();
    if (updateDate != null) {
      item['update_date'] =
          DateTime.fromMillisecondsSinceEpoch(updateDate).toIso8601String();
    }
  }

  final updatedJson = jsonEncode(jsonList);
  file.writeAsStringSync(updatedJson, flush: true);
  print('Updated job.json with formatted dates.');
}
