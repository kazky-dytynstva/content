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

    final imageCount = _candidateHelper.copyImageFiles();
    _candidateHelper.copyAudioFiles();

    final tags = this.tags;

    final text = _candidateHelper.getTaleTextFromFile();
    if (text != null) tags.add(TaleTag.text);

    final audio = _getAudio();
    if (audio != null) tags.add(TaleTag.audio);

    // for now only 1 chapter can be created
    final chapter = ChapterDto(
      title: null,
      text: text,
      imageCount: imageCount,
      audio: audio,
    );

    return TaleDto(
      id: newTaleId,
      name: name,
      createDate: DateTime.now().millisecondsSinceEpoch,
      updateDate: null,
      tags: tags,
      content: [chapter],
      crew: crew,
      ignore: true,
    );
  }

  ChapterAudioDto? _getAudio() {
    final data = _candidateHelper.getAudioData();
    if (data == null) return null;

    return ChapterAudioDto(
      size: data.size,
      duration: data.duration.inMilliseconds,
    );
  }

  void createTaleDir({required int newTaleId}) {
    final taleDir = contentDirProvider.createTaleDirectory(taleId: newTaleId);
    _candidateHelper.setTaleDirectory(taleDir);
    taleDirectory = taleDir;
  }
}
