import 'dart:io';

import 'package:migration/operation/operation.dart';

const _candidatePath = '../content_candidate';
const _dataPath = '../data';
const _dataVersion = 2;

abstract class ContentDirectoryProvider {
  const factory ContentDirectoryProvider(ContentType type) =
      _ContentDirectoryProviderImpl;

  Directory get contentCandidate;
  Directory get content;

  Directory createTaleDirectory({required int taleId});

  void clearCandidate();
}

class _ContentDirectoryProviderImpl implements ContentDirectoryProvider {
  const _ContentDirectoryProviderImpl(this._type);

  final ContentType _type;

  @override
  Directory get contentCandidate {
    late final String path;
    switch (_type) {
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

  @override
  Directory get content {
    late final String path;
    switch (_type) {
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

  @override
  void clearCandidate() {
    contentCandidate.listSync().forEach((element) {
      element.deleteSync(recursive: true);
    });
  }

  @override
  Directory createTaleDirectory({required int taleId}) {
    final path = '${content.path}$taleId/0/';
    final dir = Directory(path);
    if (dir.existsSync()) {
      throw StateError('Tale directory already exist');
    }
    dir.createSync(recursive: true);
    return dir;
  }
}
