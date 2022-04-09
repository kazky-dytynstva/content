import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Пасха';

  @override
  Set<String> get extraTags => {};

  @override
  TaleCrewDto? _getCrew() => TaleCrewDto(
        authors: [79],
        readers: [79],
        musicians: null,
        translators: null,
        graphics: null,
      );

  @override
  ChapterAudioDto? _getAudio({
    required int chapterIndex,
  }) {
    final data = getAudioData(audioPath(chapterIndex));
    return ChapterAudioDto(
      size: data.size,
      duration: data.duration.inMilliseconds,
    );
  }

  @override
  List<String>? _getText() => [
        "У невеличкому лісі жило маленьке Зайченя – Вухастик, яке з нетерпінням чекало на Великдень, адже його улюбленим заняттям було розфарбовування писанок. Настала субота – день, коли матуся пече паски, розфарбовує крашанки.",
        "– Матусю, – мовив Вухастик, – я хочу допомогти тобі розфарбовувати писанки.",
        "– Добре, йди-но до курятнику, попроси у курочки яйце, – сказала мама.",
        "Зайчику стало не по собі, адже понад усе він боявся півня, який міг дзьобнути маленького. Вухастик з обережністю відчинив скрипучі двері курятнику, виглянув один оком із-за дверей.",
        "– Бррр... страшно, – мовило зайченя.",
        "– Куд-кудах... тобі чого, Вухастику, – прокудкудахлала квочка.",
        "– Я хочу розфарбувати великоднє яйце, тому мама сказала йти до вас.",
        "– То чого ти весь трясешся?",
        "– Минулого разу, коли я прийшов по яйця, мене клюнув півень. Курочка сміючись сказала: «Авжеж, ти ж хотів забрати його дитя. Тому він злився на тебе».",
        "– Я не хотів забрати його дитя, мені потрібно було лише яйце,– сказав Вухастик.",
        "– У середині яйця знаходиться зародок майбутнього циплятка. Ми, курочки, висиджуємо яйця протягом 20 днів, а потім на світ з’являються жовтенькі циплятка.",
        "– Невже! – з подивом вигукнуло зайченя й додало: я й не знав цього. Тепер зрозуміло, чого півник мене не любить.",
        "– Ко-ко-ко! Але я знаю, Вухастику, як ти любиш розфарбовувати писанки, тому залюбки поділюся з тобою одним яйцем. Воно порожнє, без ципля. Ось, тримай.",
        "– Дякую, курочко, ти дуже добра.",
        "Вухастик пострибав до свого будиночку. – Матусю, мені курочка дала яйце. Тепер я зрозумів, чому півник ганяв мене, бо це майбутнє ципля.",
        "– Саме так, Вухастику. Тож почнімо фарбувати?",
        "Вухастик узяв фарби, пензлик и скляночку води. Пензлик у мочив у воду, набрав фарби на кінчик й почав розфарбовувати.",
        "– Готово! – сказало зайченя і простягнуло до мами лапку з розфарбованою писанкою.",
        "– Яка краса, – мовила матуся.",
        "На яйці було намальоване мале ципля, курочка і півник, якого більше не боявся Вухастик.",
        "– Це яйце стане справжнім символом Великодня,– мовила матуся й поклала його у кошик.",
      ];
}

abstract class _AddTaleHelper extends BaseAddHelper {
  _AddTaleHelper(From2to2 migration)
      : super(
          migration,
          addItemName: 'Tale',
          folderName: 'tales',
        );

  late TaleDto tale;

  String getTalePath(int chapterIndex) => '$dataPath/$nextId/$chapterIndex/';

  String audioPath(int chapterIndex) => getTalePath(chapterIndex) + 'audio.mp3';

  @override
  Future<bool> validate({bool post = false}) async {
    try {
      final all = await getAll();

      final idList = all.map((e) => e.id).toSet();

      assert(
        idList.length == all.length,
        'Looks like we have duplicate',
      );

      if (!post) {
        nextId = (await _getLastId()) + 1;
      }

      final chapterIndex = 0;
      final path = getTalePath(chapterIndex);
      final dir = Directory(path + 'img');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
        migration.log('Empty folder for tale was created');
        throw Exception('Please add some content to the tale folder');
      }

      if (post) {
        final imageFile = File(path + 'img/0.jpg');
        assert(
          imageFile.existsSync(),
          'Image for the tale was not found',
        );

        if (tale.tags.contains(Tags.audio)) {
          final audioFile = File(path + 'audio.mp3');
          assert(
            audioFile.existsSync(),
            'Image for the tale was not found',
          );
        }
      }
      return true;
    } catch (e) {
      migration.log(e.toString());
      return false;
    }
  }

  Future<List<TaleDto>> getAll() async {
    final json = await migration.readJsonList(jsonPath);
    final people = json.map((e) => TaleDto.fromJson(e)).toList();
    if (originalList.isEmpty) {
      originalList.addAll(people);
    }
    return people;
  }

  Future<int> _getLastId() async {
    final people = (await getAll()).map((e) => e.id);
    return people.reduce(max);
  }

  @override
  Future<void> add() async {
    final createDateDelta = const Duration(days: 1).inMilliseconds;

    final crew = _getCrew();

    final content = _getContent();
    final tags = <String>{
      if (content.first.text != null) Tags.text,
      if (content.first.audio != null) Tags.audio,
      if (crew?.authors?.isNotEmpty == true) Tags.author,
    }..addAll(extraTags);

    tale = TaleDto(
      id: nextId,
      name: taleName,
      createDate: DateTime.now().millisecondsSinceEpoch + createDateDelta,
      tags: tags,
      content: content,
      crew: crew,
      ignore: true,
    );

    final all = await getAll();
    all.add(tale);
    await saveJson(all);
  }

  String get taleName;

  TaleCrewDto? _getCrew();

  /// Other than [Tags.author],[Tags.text],[Tags.audio]
  Set<String> get extraTags;

  List<TaleChapterDto> _getContent() => [
        _createChapter0(),
      ];

  TaleChapterDto _createChapter0() => TaleChapterDto(
        title: null,
        imageCount: 1,
        text: _getText(),
        audio: _getAudio(chapterIndex: 0),
      );

  ChapterAudioDto? _getAudio({
    required int chapterIndex,
  });

  List<String>? _getText();
}

class Tags {
  Tags._();

  //region added automatically
  static const String text = 'text';
  static const String author = 'author';
  static const String audio = 'audio';

  //endregion added automatically

  static const String poem = 'poem';
  static const String lullaby = 'lullaby';
}
