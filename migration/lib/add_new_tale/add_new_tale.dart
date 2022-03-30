import 'dart:convert';
import 'dart:io';

import 'package:migration/add_new_tale/audio_util.dart';
import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';

void main() {
  final createDateDelta = const Duration(days: 2).inMilliseconds;
  const taleId = 210;
  final missing = _createDirectoriesIfMissing(taleId);
  if (missing) {
    print('directories was created 💪');
    print('now add some images and audio 😘');
    return;
  }

  final crew = _getCrew();
  final content = _getContent(taleId);
  final tags = <String>{
    if (content.first.text != null) Tags.text,
    if (content.first.audio != null) Tags.audio,
    if (crew?.authors?.isNotEmpty == true) Tags.author,
    // Tags.lullaby,
    Tags.poem,
  };

  final tale = TaleDto(
    id: taleId,
    name: 'Зозуля й півень',
    createDate: DateTime.now().millisecondsSinceEpoch + createDateDelta,
    tags: tags,
    content: content,
    crew: crew,
  );
  final jsonMap = tale.toJson();
  final string = json.encode(jsonMap);
  print(string);
}

TaleCrewDto? _getCrew() => TaleCrewDto(
      authors: [36],
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
  return null;
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

List<String>? _getText() => [
      "— Як ти співаєш, Півне, веселенько...",
      "— А ти, Зозуленько, ти, зіронько моя,",
      "Виводиш гарно так і жалібненько,",
      "Що іноді аж плачу я...",
      "Як тільки що почнеш співати,",
      "Не хочеться й пшениченьки клювати,-",
      "Біжиш в садок мерщій...",
      "— Тебе я слухала б довіку, куме мій,",
      "Аби б хотів співати...",
      "— А ти, голубонько, ти, кралечко моя,",
      "Поки співаєш на калині,",
      "То й весело мені, і забуваю я",
      "Свою недоленьку, життя своє погане",
      "Та безталанне...",
      "А тільки замовчиш",
      "Або куди летиш,-",
      "Заниє серденько, неначе на чужині...",
      "І їстоньки — не їм, і питоньки — не п'ю",
      "Та виглядаю все Зозуленьку мою.",
      "Як гляну на тебе — така ти невеличка,",
      "Моя перепеличко,",
      "А голосочок-то який!..",
      "Тонесенький, милесенький такий...",
      "Куди той соловей годиться?",
      "— Спасибі, братику, за добреє слівце.",
      "Як не кохать тебе за це?..",
      "І ти виспівуєш, неначе та жар-птиця;",
      "І далебі, що так,— пошлюся я на всіх.-",
      "Де взявся Горобець, підслухав трохи їх",
      "Та й каже: — Годі вам брехати",
      "Та одно другого знічев'я вихваляти! —",
      "Пурхнув — та й був такий.",
      " ",
      "За що ж,— хто-небудь попитає,-",
      "Зозуля Півня вихваляє?",
      "За те, що Півень годить їй",
      "Та потакати добре вміє:",
      "Рука, як кажуть, руку миє.",
    ];

class Tags {
  Tags._();

  static const String text = 'text';
  static const String author = 'author';
  static const String audio = 'audio';
  static const String poem = 'poem';
  static const String lullaby = 'lullaby';
}
