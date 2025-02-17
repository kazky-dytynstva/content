import 'dart:convert';
import 'dart:io';

void main() {
  final file =
      File('/Users/andrii.antonov/dev/kazky/content/data/3/tales/list.json');
  final content = file.readAsStringSync();
  final jsonContent = jsonDecode(content) as List<dynamic>;

  for (final item in jsonContent) {
    item as Map<String, dynamic>;

    item['summary'] =
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient.';
  }

  file.writeAsStringSync(jsonEncode(jsonContent));

  // // final newFile =
  // //     File('/Users/andrii.antonov/dev/kazky/content/data/3/tales/action.json');
  // // newFile.writeAsStringSync(jsonEncode(result));

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
  String csv = ListToCsvConverter().convert(
    rows,
  );

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
