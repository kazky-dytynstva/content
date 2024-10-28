import 'dart:convert';
import 'dart:io';

import 'package:dto/dto.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:migration/utils/content_directory_provider.dart';
import 'package:migration/utils/function_logger.dart';

const _candidatePath = '../content_candidate';
const _dataPath = '../data';
const _dataVersion = 2;

enum OperationType {
  add,
  edit,
}

enum ContentType {
  person,
  tale,
}

abstract class Operation<T extends ToJsonItem> {
  Operation(
    this.operationType,
    this.contentType,
  ) {
    logger.start();
  }

  final OperationType operationType;
  final ContentType contentType;
  late final contentDirProvider = ContentDirectoryProvider(contentType);
  late final logger = FunctionLogger(
    name: '${operationType.name} ${contentType.name} operation',
  );

  T itemFromJson(Map<String, dynamic> json);

  Map<String, dynamic> itemToJson(T item);

  IList<T> modify(IList<T> list);

  Exception? validate(IList<T> list);

  void fallback() {}

  void operationCompleted() {}

  void execute() {
    final jsonFile = _jsonFile;
    final initialData = _getInitialData(jsonFile);
    try {
      logger.info('Start "modify"');
      final updated = modify(initialData);
      logger.info('"modify" - done ✅');

      logger.info('Start "validate"');
      final invalidException = validate(updated);
      logger.info('"validate" - done ✅');

      if (invalidException != null) {
        throw logger.failure('Validation failed!\n$invalidException');
      }

      logger.info('Start "store data"');
      _storeDataToFile(updated, jsonFile);
      logger.info('"store data" - done ✅');
      operationCompleted();
      
      logger.success('Completed');
    } catch (e, trace) {
      logger.info('Start "fallback"');
      fallback();
      logger.info('"fallback" - done ✅');
      throw logger.failure(
        'Exception occurred 😱\n'
        '$e\n'
        '$trace',
      );
    }
  }

  Directory get contentCandidateDirectory {
    late final String path;
    switch (contentType) {
      case ContentType.person:
        path = '$_candidatePath/person/';
        break;
      case ContentType.tale:
        path = '$_candidatePath/tale/';
        break;
    }
    final directory = Directory(path);
    if (!directory.existsSync()) {
      throw StateError('Content candidate directory not found');
    }
    return directory;
  }

  Directory get contentDirectory {
    late final String path;
    switch (contentType) {
      case ContentType.person:
        path = '$_dataPath/$_dataVersion/people/';
        break;
      case ContentType.tale:
        path = '$_dataPath/$_dataVersion/tales/';
        break;
    }
    final directory = Directory(path);
    if (!directory.existsSync()) {
      throw StateError('Content directory not found');
    }
    return directory;
  }

  File get _jsonFile {
    final String path = '${contentDirectory.path}list.json';
    final file = File(path);
    if (!file.existsSync()) {
      throw StateError('Json file with content not found');
    }
    return file;
  }

  IList<T> _getInitialData(File jsonFile) {
    final stringData = jsonFile.readAsStringSync();
    return _decodeJsonFromString(jsonData: stringData);
  }

  IList<T> _decodeJsonFromString({required String jsonData}) {
    final jsonList = jsonDecode(jsonData);
    if (jsonList is! List) {
      throw Exception('Json file ($jsonData) is not a list');
    }
    return jsonList.map((e) => itemFromJson(e)).toIList();
  }

  void _storeDataToFile(IList<T> data, File jsonFile) {
    final sorted = data.sort((a, b) => b.id.compareTo(a.id));
    final jsonList = sorted.map(itemToJson).toList();
    _saveJsonListToFile(
      data: jsonList,
      jsonFile: jsonFile,
    );
  }

  void _saveJsonListToFile({
    required List<Map<String, dynamic>> data,
    required File jsonFile,
  }) {
    final encoder = JsonEncoder.withIndent('  ');
    final str = encoder.convert(data);

    if (jsonFile.existsSync()) {
      jsonFile.deleteSync();
    }

    jsonFile.createSync();

    jsonFile.writeAsStringSync(str);
  }
}
