import 'dart:io';

import 'package:dto/dto.dart';
import 'package:migration/operation/operation.dart';
import 'package:migration/operation/tale/tale_operation.dart';
import 'package:migration/utils/tale_candidate_helper.dart';

void main() {
  _SimpleAddTaleOperation().execute();
}

class _SimpleAddTaleOperation extends _AddTaleOperation {
  @override
  String get name => 'Нова казка';

  @override
  Set<TaleTag> get tags => {};

  @override
  CrewDto? get crew {
    return null;
    return CrewDto(
      authors: null,
      readers: null,
      musicians: null,
      translators: null,
      graphics: null,
    );
  }
}

abstract class _AddTaleOperation extends TaleOperation {
  _AddTaleOperation() : super(OperationType.add);

  //////////
  String get name;

  Set<TaleTag> get tags;

  CrewDto? get crew;
  //////////

  late final _candidateHelper = TaleCandidateHelper(
    contentDirProvider,
    logger,
  );
  Directory? taleDirectory;

  @override
  void fallback() {
    taleDirectory?.deleteSync(recursive: true);
  }

  @override
  TaleDto getNew({required int newTaleId}) {
    createTaleDir(newTaleId: newTaleId);

    _candidateHelper.copyAudioFiles();

    final tags = this.tags;

    final text = _getTextContent();
    if (text != null) {
      tags.add(TaleTag.text);
    }

    final audio = _getAudioContent();

    if (audio != null) {
      tags.add(TaleTag.audio);
    }

    return TaleDto(
      id: newTaleId,
      name: name,
      createDate: DateTime.now().millisecondsSinceEpoch,
      updateDate: null,
      tags: tags,
      text: text,
      audio: audio,
      crew: crew,
      ignore: true,
    );
  }

  TextContentDto? _getTextContent() {
    final text = _candidateHelper.getTaleTextFromFile();
    if (text == null) return null;

    return TextContentDto(
      text: text,
      minReadingTime: 1,
      maxReadingTime: 2,
    );
  }

  AudioContentDto? _getAudioContent() {
    final data = _candidateHelper.getAudioData();
    if (data == null) return null;

    return AudioContentDto(
      fileSize: data.size,
      duration: data.duration.inMilliseconds,
    );
  }

  void createTaleDir({required int newTaleId}) {
    final taleDir = contentDirProvider.createTaleDirectory(taleId: newTaleId);
    _candidateHelper.setTaleDirectory(taleDir);
    taleDirectory = taleDir;
  }
}
