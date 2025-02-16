import 'dart:io';

import 'package:migration/utils/audio_util.dart';
import 'package:migration/utils/content_directory_provider.dart';
import 'package:migration/utils/function_logger.dart';

abstract class TaleCandidateHelper {
  factory TaleCandidateHelper(
    ContentDirectoryProvider directoryProvider,
    FunctionLogger logger,
  ) = _TaleCandidateHelperImpl;

  void setTaleDirectory(Directory directory);

  void copyAudioFiles();

  List<String>? getTaleTextFromFile();

  AudioUtilData? getAudioData();
}

class _TaleCandidateHelperImpl implements TaleCandidateHelper {
  _TaleCandidateHelperImpl(
    this.directoryProvider,
    this.logger,
  );

  late final Directory _taleDirectory;
  final ContentDirectoryProvider directoryProvider;
  final FunctionLogger logger;

  Directory get _candidateDir => directoryProvider.contentCandidate;

  @override
  void setTaleDirectory(Directory directory) {
    _taleDirectory = directory;
  }

  @override
  int copyImageFiles() {
    final imageDir = Directory('${_taleDirectory.path}img');
    imageDir.createSync();

    final imageEntities = _candidateDir.listSync().where((element) {
      return element.path.endsWith('.jpg');
    });

    if (imageEntities.isEmpty) {
      throw StateError('Tale candidate should containt at least 1 jpg image');
    }

    for (final entity in imageEntities) {
      final file = File(entity.path);
      final lastPathSegment = Uri.parse(file.path).pathSegments.last;
      final chanks = lastPathSegment.split('.');
      final newPath =
          '${imageDir.path}/${chanks.first}.original.${chanks.last}';
      file.copySync(newPath);
    }

    return imageEntities.length;
  }

  @override
  void copyAudioFiles() {
    final mp3Files = _candidateDir.listSync().where((element) {
      return element.path.endsWith('.mp3');
    });

    if (mp3Files.isEmpty) return;

    final originalName = 'audio.original.mp3';
    final compressedAudioFileName = 'audio.mp3';

    final originalEntity = mp3Files.firstWhere(
      (element) => element.path.contains(originalName),
      orElse: () {
        throw StateError('Tale candidate should contains $originalName file');
      },
    );

    final compressedEntity = mp3Files.firstWhere(
      (element) => element.path.contains(compressedAudioFileName),
      orElse: () {
        throw StateError(
          'Tale candidate should contains $compressedAudioFileName file',
        );
      },
    );

    void copy(FileSystemEntity entity, String name) {
      final file = File(mp3Files.first.path);
      final newPath = '${_taleDirectory.path}$name';
      file.copySync(newPath);
    }

    copy(originalEntity, originalName);
    copy(compressedEntity, compressedAudioFileName);
  }

  @override
  List<String>? getTaleTextFromFile() {
    final file = File('${_candidateDir.path}text.txt');
    if (!file.existsSync()) {
      logger.info('Tale text.txt was not found 🤷‍♂️');
      return null;
    }

    final content = file.readAsStringSync();

    if (content.isEmpty) {
      throw StateError('Tale candidate text should be NOT empty');
    }

    final split = content.split('\n');

    if (split.length <= 1) {
      throw StateError('Tale candidate text should be multiline');
    }

    final spaceRegExp = RegExp(r"\s{2,}");

    return split
        .map((text) => text.replaceAll(spaceRegExp, ' '))
        .map((text) => text.trim())
        .toList();
  }

  @override
  AudioUtilData? getAudioData() {
    final path = '${_taleDirectory.path}audio.mp3';
    final file = File(path);
    if (!file.existsSync()) return null;

    return getAudioUtilData(file.path);
  }
}
