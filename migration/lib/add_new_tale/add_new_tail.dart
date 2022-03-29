import 'dart:convert';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';

void main() {
  final createDateDelta = const Duration(days: 3).inMilliseconds;
  const taleId = 208;
  final tale = TaleDto(
    id: taleId,
    name: 'Курочка Ряба',
    createDate: DateTime.now().millisecondsSinceEpoch + createDateDelta,
    tags: {
      Tags.text,
      Tags.author,
    },
    content: _getContent(taleId),
    crew: _getCrew(),
  );
  final jsonMap = tale.toJson();
  final string = json.encode(jsonMap);
  print(string);
}

TaleCrewDto? _getCrew() => TaleCrewDto(
      authors: [6],
      readers: null,
      musicians: null,
      translators: null,
      graphics: null,
    );

List<TaleChapterDto> _getContent(int taleId) {
  final chapter = TaleChapterDto(
    title: null,
    imageCount: 1,
    text: _getText(),
    audio: _getAudio(taleId),
  );
  return [chapter];
}

ChapterAudioDto? _getAudio(int taleId) {
  return null;
  // final path = '../data/2/tales/$taleId/0/audio.mp3';
  // final data = getAudioData(path);
  // return ChapterAudioDto(
  //   size: data.size,
  //   duration: data.duration.inMilliseconds,
  // );
}

List<String> _getText() => [
      "Жили були дід і баба. І була у них Курочка Ряба.",
      "А були ці дідусь з бабусею такі бідні, що нікого й нічого, крім Курочки, не мали.",
      "Навіть їли лише яйця та городину.",
      "За їхню доброту Курочка знесла золоте яєчко.",
      "Але жили вони на хуторі, та й була справа зимою, тому задумали дід з бабою це яйце з'їсти.",
      "Взявся дід бити золоте яйце, та не розбив. Баба била, била. І також не розбила.",
      "А з-під лавки за всім цим спостерігало маленьке мишеня. Воно також давно вже не їло, тому задумало золоте яйце собі забрати, якщо дід з бабою його розбити не можуть.",
      "От мишеня вибігло, але не встигло воно взяти яйце у лапки, як те покотилось, впало на глиняну підлогу і... розбилось. Та сіренький шкідник не розгубився, він білка свіжого напився.",
      "Дід плаче, баба плаче, а Курочка Ряба кудкудахче:",
      "- Не плач, діду, не плач, бабо. Зберіть золоті рештки - підете в місто, продасте, гусей і півника купите. А я знесу вам інше яєчко - не золоте, а просте.",
      "От навесні дід з бабою розбагатіли, а влітку Курочка Ряба по двору курчаток водила.",
    ];

class Tags {
  Tags._();

  static const String text = 'text';
  static const String author = 'author';
  static const String audio = 'audio';
  static const String poem = 'poem';
  static const String lullaby = 'lullaby';
}
