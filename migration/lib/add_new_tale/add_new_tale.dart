import 'dart:convert';
import 'dart:io';

import 'package:migration/add_new_tale/audio_util.dart';
import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';

void main() {
  final createDateDelta = const Duration(days: 3).inMilliseconds;
  const taleId = 209;
  final missing = _createDirectoriesIfMissing(taleId);
  if (missing) {
    print('directories was created 💪');
    print('now add some images and audio 😘');
    return;
  }
  final tale = TaleDto(
    id: taleId,
    name: 'Кіт в чоботях',
    createDate: DateTime.now().millisecondsSinceEpoch + createDateDelta,
    tags: {
      Tags.author,
      Tags.audio,
    },
    content: _getContent(taleId),
    crew: _getCrew(),
  );
  final jsonMap = tale.toJson();
  final string = json.encode(jsonMap);
  print(string);
}

TaleCrewDto? _getCrew() => TaleCrewDto(
      authors: [77],
      readers: null,
      musicians: null,
      translators: null,
      graphics: null,
    );

List<TaleChapterDto> _getContent(int taleId) => [
      _createChapter0(taleId),
    ];

TaleChapterDto _createChapter0(int taleId) => TaleChapterDto(
      title: null,
      imageCount: 1,
      text: _getText(),
      audio: _getAudio(taleId: taleId, chapterIndex: 0),
    );

ChapterAudioDto? _getAudio({
  required int taleId,
  required int chapterIndex,
}) {
  final path = _getDirPath(taleId) + '$chapterIndex/audio.mp3';
  final data = getAudioData(path);
  return ChapterAudioDto(
    size: data.size,
    duration: data.duration.inMilliseconds,
  );
}

/// return true, if directories are missing
bool _createDirectoriesIfMissing(int taleId) {
  final path = _getDirPath(taleId) + '0/img';
  final dir = Directory(path);
  final missing = !dir.existsSync();
  if (missing) {
    dir.createSync(recursive: true);
  }
  return missing;
}

String _getDirPath(int taleId) => '../data/2/tales/$taleId/';

List<String>? _getText() => null;

class Tags {
  Tags._();

  static const String text = 'text';
  static const String author = 'author';
  static const String audio = 'audio';
  static const String poem = 'poem';
  static const String lullaby = 'lullaby';
}
