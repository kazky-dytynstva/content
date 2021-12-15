import 'dart:convert';
import 'dart:io';

const _dataPath = '../data';

abstract class BaseDataMigration {
  final int oldDataVersion, newDataVersion;

  BaseDataMigration({
    required this.oldDataVersion,
  })  : assert(oldDataVersion >= 0),
        newDataVersion = oldDataVersion + 1;

  String get oldDataPath => '$_dataPath/$oldDataVersion';

  String get newDataPath => '$_dataPath/$newDataVersion';

  Future<void> run() async {
    Future<void> cleanNewDirectory() async {
      final directory = Directory(newDataPath);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }

    _logImportantMessages([
      'Migration started 🚀',
      'from version #$oldDataVersion to #$newDataVersion',
    ]);
    await cleanNewDirectory();
    if (await migrate()) {
      _logImportantMessages([
        'Migration completed 🎉',
        'Check out new data at $newDataPath',
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
    final file = File(filePath);

    await file.create(recursive: true);

    if (file.existsSync()) {
      file.deleteSync();
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
}
