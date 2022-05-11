import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Киця-Кицюня та знайдений апетит';

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
        "Жила собі, була собі кошача родина. І росли в цій родині троє кошенят. Двоє хлопчиків-котиків та одна кішечка-дівчинка. Молодша вона була. Звали її Киця-Кицюня. А коли вона ласкаво муркотіла, то кликали Мур-Кицею обо Мур-Кицюнею.",
        "Малі кошенята, як малі діти, гралися-бавилися цілий день. Смачно їли, що їхня матінка Муркатінка готувала. Та спали солодко, згорнівшися в клубочки.",
        "Та ось одного дня покликала обідати матінка Муркатінка своїх малюків піхнастих. Старші брат з сестрою добре й смачно поїли. А мала Киця-Кицюня лише понюхала кашку молочну. Один разок лизнула, хвостиком мотнула та й пішла собі гратися. На другий день теж саме. Вухами повела, вусиками покрутила, мисочку з молочною кашею понюхала, та не ївши, пішла собі гуляти. Стурбувалася кішка-матінка Муркатінка: що трапилося? Де подівся апетит малою Киці-Кицюні? Чи загубився? То ж каже доньці:",
        "- Кашка корисна, молочна, смачненька!\nРости тобі потрібно! Їж, моя, маленька!",
        "А мала не хоче їсти. Грається, бавиться. Вже вся родина турбується: де апетит Кицюнін загубився? Куди подівся? Дідусь з бабусею почали маленьку онучку вмовляти:",
        "- З'їж, Киця, кашу смачненьку!\nОдну ложку за неньку,\nдругу за татуся.\nТретю за бабусю.\nКаша корисна, молочна, біленька,\nБо готувала рідная ненька!",
        "А мала Киця лише хитренько посміхається, стрибає, бігає, грається. Їсти не хоче. То ж вірішила родина кошача, нехай дідусь з бабусею з малою підуть. По сусідах, по садах та городах апетит Кицюнін шукати. Нехай подивляться, чим сусіди діточок своїх годують, що б апетит у малих не губився.",
        "Йдуть, дивляться: сім'я зайців своїх діточок-зайченят морквою годує. Хрумкотять малі з апетитом, аж за вухами у них тріщить! То ж кіт-дідусь Муркотусь і каже:",
        "- Онученька, Киця, поглянь, яка морквиця!\nСоковита, смачненька! Скуштуй, моя маленька!",
        "Понюхала Киця-Кицюня моркву. Вушками повела, голівкою похитала: не смачно! Не хоче їсти. То й пішли вони далі. На узліссі під великим дубом родина кабанів своїх малих поросяток-кабаняток годує. Смакують поросятка жолуді, хрумкотять, ласують! Смачно їм! Почали й малу Кицю пригощати. Але жолуді тверді, ні сметанкою, ні молочком, ні вершками не пахнуть. Понюхала Кицюня, скривилася. Лапкою жолуді покачала. Погралася, а їсти не хоче. Не смачно їй!",
        "То ж пішли далі апетит шукати. Ходили-ходили... Вже й вечір близенько. Бачать під березою у тіньочку родина їжаків грибами ласує, вечеряє. Доброзичливі, привітні. Кицю пригощають:",
        "- Скуштуй опеньки або маслят, маленька!\nГриби духмяні! Бери й для юшки мамі!",
        "Подякували Киця-Кицюня їжачкам, бо ввічлива була. Але їсти не стала: не смачно! Не кошача це їжа.",
        "Довго ходили, цілий день блукали. Втомилася маленька Киця, зголодніла, бо цілий день в мисочку свою не зазирала. Як вскочила в хатинку, та й просить:",
        "- Матуся, рідненька!\nДе сметанка смачненька?\nЖолудів, грибів не хочу!\nЗ'їм всю кашу!",
        "Аж муркоче!",
        "Сіли вечеряти всією кошачою родиною. Киця раніше за всіх свою вечерю з'їла: і кашку, і сметанку, і ковбаси кільце, ще й варене яйце! Мисочку вилизала, добавки просить! Апетит гарний, добрий! Апетит до Кицюні повернувся! Матінка Муркатінка радіє за кошенятко своє: гарно їсть, здорове зросте!",
        "А Кицюня пішла у комору й принесла звідтіля обгортки від цукерок. Та й розповіла, що знайшла якось у садочку три цукерки. Мабуть сусідський хлопчик загубив. То й їла по цукерочці три дні поспіль. Розсміявся кіт- дідусь Муркотусь:",
        "- Тепер зрозуміло, де апетит Кицін подівся. Солодкі-солодющі цукерки його поцупили!",
        "А матуся з татусем обійняли доню та й говорять:",
        "- Бережи свій апетит від цукерок! Їж кашу молочну смачненьку та сметанку свіженьку, ковбаски кільце, ще й варене яйце! М'ясну рульку та рибу барабульку! Бо вони здоров'я добавляють. Та зростати кошенятам допомагають.",
        "Зрозуміла все Киця-Кицюня. Більше цукерок не їла. Апетит свій від них оберігала. Тільки з обгортками й гралася. Розумниця!",
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
