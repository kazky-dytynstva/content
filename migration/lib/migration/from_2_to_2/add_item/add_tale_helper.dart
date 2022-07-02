import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Собачка Кетті та гість з Африки';

  @override
  Set<String> get extraTags => {};

  @override
  TaleCrewDto? _getCrew() => TaleCrewDto(
        authors: [_irynaGarmash],
        readers: [_irynaGarmash],
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
        "Якщо ви пам’ятаєте, то Кетті- це кумедне веселе цуценятко-дівчинка, яка дуже любить гуляти у парку при любій погоді. В неї є родина-собачок: мама й татко. А ще часто приїздить в гості бабуся.",
        "Втім, сьогодні розповідь буде про Кетті та її сусідів. Поряд з сім’єю собачок мешкає родина котів. Це поважний пан Кіт-Кото та його дружина пані Кішка-Кото. Вони дуже гостинні. До них часто приїздять діти з малими онуками та родичі-гості. Обидві родини мирно й доброзичливо спілкуються. Кетті любить, коли приїздять кошенята-онуки. Тоді вони разом бавляться цілий-цілесенький день. Багато різних ігор знають веселі спритні пухнастики.",
        "Та одного зимового дня пан Кіт-Кото повідомив, що чекає на приїзд свого родича-пана Лео. Пан Лео живе дуже далеко: у спекотній Африці. Це такий величезний континент на планеті Земля. Там завжди жарко. Якесь суцільне літо! Тож пан Лео (справжнісінький африканській леопард!) ніколи не бачів снігу! І дуже мріє покататися на санчатах з льодяної гірки. А ще хоче побачити справжню новорічну ялинку.",
        "Цуцетяткові Кетті було не зрозуміло: невже таке можливо? Як це, завжди жарко? Бо вона бачила кожного року чотири сезони. І навіть знала їх назви: зима, весна, літо й осінь. Кетті розуміла, що такий порядок і пори року змінюють одна одну. Зима, весна, літо й осінь. І кожна пора року їй подобалася по-свойому. Хоч погода дуже відрізнялася восени, від літньої. А взимку від весняної. То ж маленька допитлива Кетті нетерпляче чекала котячого родича з Африки та його розповіді.",
        "Аж ось пан Кіт-Кото запросив родину собачок у гості: поспілкуватися з довгоочікуваним африканським мешканцем. Пан Лео був величезним плямистим котом з довгим хвостом. Одягнений він був у барвисту футболку з малюнками пальм і океану та досить короткі літні штани. На голові у нього важно посідав солом’яний капелюх від сонця. «Оце так,- подумала Кети.- Пан Лео одягнувся, начебто на пляж зібрався!» Але, ввічливо промовчала. Бо була дуже вихованим цуценям.",
        "Пан Лео розповідав про спекотну Африку, палюче сонце, своїх друзів та родичів: левів, слонів і носорога. Про політ у літаку та поїздку в таксі. А ще привіз всім подарунки. Кетті отримала величезний ананас.",
        "А потім всі гуртом заходилися прикрашати новорічну ялинку. Пан Лео, хоч і дорослий, був у захваті! Милувався кожною іграшкою та гірляндою. Бо він вперше у житті розвішував новорічні прикраси на зеленій колючий ялинці.",
        "За вікном пішов сніг. То ж вирішили йти на прогулянку. Всі тепло одягнулися, щоб вийти на вулицю. Ой-ой! Пан Лео вирішив йти в своєму солом’яному капелюсі й футболці з пальмами. «Шановний, пане Лео!- не втрималася Кети.- Так не можно йти: на вулиці мороз! Потрібно тепло одягатися». Та гість зі спекотної Африки не розумів, що таке мороз. «Я не змерзну! Буду швидко бігати та з гірки льодяної кататися!» Пан Кіт-Кото лише всміхнувся, бо знав впертість свого родича: «Зараз сам зрозуміє, що таке мороз!»",
        "Вийшли на вулицю. Пан Лео стрімко плигнув у сніг: «Ура! Я бачу сніг! Я можу пірнати у сніг! Стрімко біжимо на гірку!» Та радість його швидко пройшла: «Брррр! Брррр! Як холодно! Ого, як ніс пече! Це мороз такий?» Лапи мерзнуть, вуха під легеньким капелюхом мерзнуть. У спину холодить, вітер колючий провіває. Навіть пальмам на футболці холодно! Змерз миттєво гість з Африки. Так і захворити можно. «Біжи в теплу квартиру швиденько!- каже пан Кіт-Кото.- Та одягайся тепло! Бо ми на тебе чекали. Пані Кішка-Кото зшила з ковдри величезне пальто з капюшоном для родича. А собачка-бабуся Кетті зв’язала теплі носки й рукавички. А я тобі теплу шапку приготував у подарунок!»",
        "Ото так і вдягли родича з теплих країв! Зрадів він, одягнувся, зігрівся! А як почав з гірки кататися, ще тепліше йому стало. Кетті разом з усіма бігала й бавилася сніжками. Навіть снігову бабу зробили з носом-морквою! А ввечорі приїхали онуки-кошенята, щоб Новий рік зустрічати. Весело й радісно свято відбулося! А коли пан Лео зібрався додому, сказав, що такого гарного, сніжного, незвичного Нового року в нього ще ніколи не було!",
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

const int _olgaTokar = 87;
const int _oskarSandler = 86;
const int _mykolaSom = 85;
const int _tinaKarol = 84;
const int _irynaGarmash = 83;
//
// const int "Тіна Кароль" = 84;
//
// const int "Ірина Гармаш" = 83;
//
// const int "Руслан Грех" = 82;
//
// const int "Леся Горова" = 81;
//
// const int "Діна Кравцова" = 80;
//
// const int "Анна Чернявська" = 79;
//
// const int "Ніка Балаж" = 78;
//
// const int "Шарль Перро" = 77;
//
// const int "Уля " = 76;
//
// const int "Алла Мігай" = 75;
//
// const int "Емілія Саталкіна" = 74;
//
// const int "Кость Дяченко" = 73;
//
// const int "Сашко Лірник" = 72;
//
// const int "Михайло Слабошпицький" = 71;
//
// const int "Анатолій Давидов" = 70;
//
// const int "Василь Вакуленко" = 69;
//
// const int "Євгенія Бурчак" = 68;
//
// const int "Вікторія Кузьміна" = 67;
//
// const int "Тарас Сліпець" = 66;
//
// const int "Оксана Смільська" = 65;
//
// const int "Владислава Сойма = 64;
//
// const int "Анатолій Михайленко" = 63;
//
// const int "Віра Карасьова = 62;
//
// const int "Микола Стеценко" = 61;
//
// const int "Олег Буцень" = 60;
//
// const int "Мирослав Вересюк" = 59;
//
// const int "Євген Башенко = 58;
//
// const int "Костянтин Ротов" = 57;
//
// const int "Максим Незгода = 56;
//
// const int "Олександр Єрох" = 55;
//
// const int "Олена Чичик = 54;
//
// const int "Леся Борсук = 53;
//
// const int "Анастасія Ножка" = 52;
//
// const int "Юлія Антонова" = 51;
//
// const int "Андрій Антонов" = 50;
//
// const int "Джоель Гарріс" = 49;
//
// const int "Денис Проуторов" = 48;
//
// const int "Світлана Харчук" = 47;
//
// const int "Анастасія Білянська" = 46;
//
// const int "Таріна Карасівна" = 45;
//
// const int "Дмитро Соколов" = 44;
//
// const int "Керстін Шьоне" = 43;
//
// const int "Світлана Колесник = 42;
//
// const int "Забіне Больман" = 41;
//
// const int "Костянтин Ушинський" = 40;
//
// const int "Ніна Матвієнко" = 39;
//
// const int _ivanFranko = 38;
//
// const int _stepanRudanskyj = 37;
//
// const int _leonidGlibov = 36;
//
// const int _bratyGrim = 35;
//
// const int _marijkaPidgiryanka = 34;
//
// const int _myhailoStelmah = 33;
//
// const int _valentynaYurchenko = 32;
//
// const int _serhijTatienko = 31;
//
// const int _mykolaSygnaivskyj = 30;
//
// const int _irynaKyrylina = 29;
//
// const int _dmytroPavlychko = 28;
//
// const int _andrijMalyshko = 27;
//
// const int _platonMajboroda = 26;
//
// const int _nataliyaZabila = 25;
//
// const int _annaSereda = 24;
//
// const int _grygorijBojko = 23;
//
// const int _marijaHorosnytska = 22;
//
// const int _anatolijKosteckyj = 21;
//
// const int _samuilMarshak = 20;
//
// const int _ivanMalkovych = 19;
//
// const int _pavloGlaovyj = 18;
//
// const int _valentynaBajkova = 17;
//
// const int _anatolijGrygoruk = 16;
//
// const int _yulianTuvim = 15;
//
// const int _vasylChuhlib = 14;
//
// const int _yanikaTereshenko = 13;
//
// const int _viktorPavlik = 12;
//
// const int _jannaHoma = 11;
//
// const int _liliyaGudz = 10;
//
// const int _tetanaLeonteva = 9;
//
// const int _yuliaZadorojna = 8;
//
// const int _katerynaGavrylova = 7;
//
// const int _mariyaSoltysSmyrnove = 6;
//
// const int _galynaMyroslava = 5;
//
// const int _innaYavorska = 4;
//
// const int _vasylSuhomlynskyi = 3;
//
// const int _oksanaKrotyuk = 2;
//
// const int _gansAndersen = 1;
//
// const int _lesyaUkrainka = 0;
