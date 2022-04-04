import 'dart:convert';
import 'dart:io';

const _dataPath = '../data';

abstract class BaseDataMigration {
  int get appBuildNumberOld;

  String get appVersionOld;

  int get dataVersionOld;

  int get dataVersionNew => dataVersionOld + 1;

  String get dataPathOld => '$_dataPath/$dataVersionOld';

  String get dataPathNew => '$_dataPath/$dataVersionNew';

  bool canCleanNewDirectory = true;

  Future<void> run() async {
    assert(dataVersionOld >= 0);

    Future<void> cleanNewDirectory() async {
      if (!canCleanNewDirectory) return;
      final directory = Directory(dataPathNew);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }

    _logImportantMessages([
      'Migration started 🚀',
      'from version #$dataVersionOld to #$dataVersionNew',
    ]);
    await cleanNewDirectory();
    if (await migrate()) {
      await _saveReadme();
      _logImportantMessages([
        'Migration completed 🎉',
        'Check out new data at $dataPathNew',
      ]);
    } else {
      await cleanNewDirectory();
      _logImportantMessages([
        'Migration failed',
      ]);
    }
  }

  /// return [true] if migration was done successful
  /// otherwise - false
  Future<bool> migrate();

  Future<List<dynamic>> readJsonList(String jsonFilePath) async {
    final file = File(jsonFilePath);
    final str = await file.readAsString();
    return json.decode(str);
  }

  Future<void> saveJsonListToFile({
    required List<Map<String, dynamic>> data,
    required String filePath,
  }) async {
    final encoder = JsonEncoder.withIndent('  ');
    final str = encoder.convert(data);
    final file = await File(filePath).create(recursive: true);

    if (await file.exists()) {
      await file.delete();
    }

    final exist = await (await file.writeAsString(str)).exists();
    if (!exist) {
      throw ('Json file was not stored. Path: $filePath');
    }
    log('JSON was stored to $filePath');
  }

  void log(String msg) => print(msg + '\n');

  void _logImportantMessages(List<String> messages) {
    print('');
    print('================');
    messages.forEach(print);
    print('================');
    print('');
  }

  Future<void> _saveReadme() async {
    final file = File('$dataPathNew/READEME.md');

    final builder = StringBuffer(
        '## Data was migrated from version **$dataVersionOld** to **$dataVersionNew**')
      ..writeln()
      ..writeln('---------')
      ..writeln()
      ..writeln('Old data was used in the app with:')
      ..writeln(' - app build number = $appBuildNumberOld')
      ..writeln(' - app version = $appVersionOld')
      ..writeln()
      ..writeln('---------')
      ..writeln()
      ..writeln('## Modified:')
      ..writeln(' - ${DateTime.now().toUtc()}, by _migration tool_');

    await file.writeAsString(builder.toString());
  }
}
