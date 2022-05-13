import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Жабеня Ква-Квака';

  @override
  Set<String> get extraTags => {};

  @override
  TaleCrewDto? _getCrew() => TaleCrewDto(
        authors: [83],
        readers: [83],
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
        "На березі великої річки жила собі, була собі сім'я жабок. І підростало в ній крихітне жабеня на ім'я Ква -Квака. Симпатичний зелений малюк вже вмів голосно співати жаб'ячу пісе ньку:",
        "- Ква-ква! Сильний я! Враз спіймаю комаря!\nКва-квакушки! Упіймаю аж три мушки!",
        "За що старші сестри Квакою-хвастою-задавакою його прозвали. Уся жаб'яча сім'я дуже любила чистоту й порядок. Матуся симпатична Ква-Квакуся мила і прибирала в їхньому житлі. Тому будиночок під коренями старого дерева був красивим та охайним. А старші сестри жабенятка дружньо їй допомагали. Бабуся Жабуся, одягнувши красивий чистий фартух, готувала обід в надзвичайно чистих блискучих горщиках. З ранку під веселий спів татуся Ква-Квакера усі вирушали плавати в річці, вмиватися, купатися й чистити зубки.",
        "«Ква-ква! Вмивайтеся! Діти, до школи збирайтеся!» - зазвичай бадьоро  співав голова сімейства. Красиві й охайні сестри жабенятка Ква-Кваки відправлялися на заняття.",
        "Лише одне маленьке ледаче жабенятко не хотіло митися й чепуритися. Ква-Квака лінувався чистити зубки та намилювати лапки. Він намагався сховатися в густих заростях очерету від докірливих поглядів сестер. Лише іноді опускав брудні лапки у воду та… та розтирав на них бруд…",
        "- Ква-Квака, соромно бути брудним! Стрибай у воду! Вмивайся! - говорили йому засмучені батьки. А сусідські жабенята,  сміючись,  прозвали його Квакою-Невмивакою.",
        "Аж ось одного разу батьки   жабенятка поїхали у справах до далекого озера.   Та   й взяли із собою у подорож   його   сестер.",
        "А маленький  неслухняний  Невмивака  залишився удома з літньою Бабусею  Жабусею. Тільки й  чути було від нього:",
        "- Не хочу мити лапки з милом! Не стану вмивати щічки й очки! Не чиститиму зубки  вранці!",
        "Старенька зітхала: «Квака, онучок, тебе скоро ніхто не впізнає. Такий ти замурзаний та брудний». Так воно й сталося.",
        "Одного   літнього   дня сиділо жабеня на листі водяної лілеї й намагалося ловити мошок. Вздовж берега по річці пропливав його приятель каченя Кря- Кряк.",
        "- Привіт, друже! Давно не бачилися!- голосно закричало жабенятко Ква-Квака.- Як справи?",
        "Каченя  Кряк-Кряк  здивовано подивилося у   бік  Ква-Кваки і трохи перелякано запитало:",
        "- А ти хто ? Такий замурзаний і дуууууже брудний!",
        "- Це ж Я!   Твій приятель Ква-Квака.",
        "- Не може бути! Ти … Ти - незнайомий мені… неохайний бруднуля!- сказало каченя і попливло чим  далі.",
        "А сороки-білобоки  голосно розсміялися над Невмивакою. Потім прилетіла подружка жабеняти  бабка  Блакитні крильця. Але й вона не впізнала в маленькому бруднулі свого друга. Засмутилося жабеня, ледь не плаче. Вирішило воно подивитися на себе в дзеркало- у річкову воду.",
        "- Ой! Хто це?  Невже це я? - злякався Ква-Квака-Невмивака.- Так мене й матуся з татком не впізнають, коли повернуться.",
        "Намочив він лапки у воді, потер щічки. Та лише бруд розмазав… ще гірше стало.",
        "- Бабуся, бабуся  Квакуся! Дай мені мило та мочалку! Готуй",
        "скоріше ванну з  піною! І зубну пасту зі щіткою!- закричало жабеня та побігло митися, купатися.",
        "Відтоді перетворився  Квака-Невмикака  на Чистьоху-Вмиваку. Він більше ніколи не засмучував своїх батьків і  друзів. А коли у жабеняти з'явився маленький братик, то Квака- Вмивака навчив його мити лапки з милом, щоб бути завжди Чистьохою! Маленькі брати-жабенята весело пірнали у річці. І Квака- Вмивака з гордістю співав:",
        "- Ква-ква! Сильний я! Враз спіймаю комаря!\nКва-квакушки! Упіймаю аж три мушки!\nЯ-Чистьоха, Я- Вмивака.\nЯ вмиватись навчив брата!»",
      ];
}

abstract class _AddTaleHelper extends BaseAddHelper {
  _AddTaleHelper(From2to2 migration)
      : super(
          migration,
          addItemName: 'Tale',
          folderName: 'tales',
        );

  final spaceRegExp = RegExp('\\s+');
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
        text: _getText()?.map((e) => e.replaceAll(spaceRegExp, ' ')).toList(),
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
