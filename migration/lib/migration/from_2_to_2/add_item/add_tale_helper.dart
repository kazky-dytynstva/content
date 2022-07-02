import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Собачка Кетті та її чобітки';

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
        "Жили-була маленька собачка на ім’я Кетті. Чесно кажучі, це було кумедне кудлате цуценятко. Але Кетті вважала себе досить дорослою й обачливою. Жила вона в собачій родині разом з мамою й татом.",
        "Кетті дуже любила бавитися іграшками та м’ячем. Але ще більше вона любила прогулянки. Їй подобалося разом з батьками гуляти міським парком. Влітку копирсатися під височенними деревами, вишукуючи цікавинки. А взимку пірнали в снігові кучугури та катитися у тазику з льодяних гірок.",
        "Мала Кетті любила гуляти і весною, коли дзюрчали струмочки води, що з таючого снігу утворилися. І восени: навіть під дощем! Але в негоду, потрібно було взувати гумові чобітки, одягати довгий плащик та брати парасольку. Це не дуже подабалося цуценяткові, бо заважало стрімко бігати й голосно гавкати на голубів.",
        "Одного осіннього дня почала родина собачок збиратися на прогулянку до міського скверу. «Кетті, одягайте, доню! Взувай гумові чобітки на всі лапки! - сказала матуся- собачка. –Ось перший чобіток на передню лапку праву! Ось другий чобіток на передню лапку ліву! Ось третій чобіток на задню лапку праву! Ось четвертий чобіток на задню лапку ліву!» То й взули малу. І пішли гуляти. Йде Кетті та співає:",
        "\"Якщо плащик одягти,\nВ дощ гуляти можно йти!\nЯкщо взути чобітки:\nЙ у калюжі стрибати!\"",
        "Набавилося цуценятко у парку. Нагулялося, настрибалося. А ще й каштанів назбирало у маленький кошик.",
        "Прийшли додому. Матуся свої черевички швиденько зняла та пішла на кухню вечерю готувати. Кашу гречану з м’ясом та підливою. «Ти вже доросла й самостійна, доню! Сама можеш впратися з чобітками!» Почала Кетті роздягатися, чобітки свої знімати. Зняла перший чобіток з передньої лапки правої! За ним другий чобіток з передньої лапку лівої! Потім третій чобіток з задньої лапки правої! За ним четвертий чобіток з задньої лапки лівої! Потім почала з парасолькою бавитися. Та каштани кругленькі ганяти на підлозі по всій квартирі. Бігає, грається! Не помітила, як один чобіток під шафу залетів. У самий далекий кут.",
        "Покликала матуся Кетті вечеряти. Смачна каша гречана! Й морозиво на десерт! Татусь з роботи прийшов, погрався з донькою, казки про подорожі почитав. То ж і спати час маленькому цуценяті. «Спи, доню!- каже татко.- Нехай насняться гарні сни! А завтра новий день буде, підеш гуляти й бавитися!»",
        "Пролетіла темна ніч. Ранок прийшов. У віконце до Кетті зазирає, прокинутись закликає. Прокинулося цуценятко, весело підскочило. Просить маму: «Матуся, рідна! Давай сніданок швидше, будь ласка! Бо дуже хочеться йти на прогулянку!» І співати почала:",
        "\"Якщо плащик одягти,\nВ дощ гуляти можно йти!\nЯкщо взути чобітки:\nЙ у калюжі стрибати!\"",
        "Поснідала Кетті добре й почала одягатися. З бабусею підуть гуляти. Вдягла плащик. Почала взуватися: перший чобіток на передню лапку праву! Ось другий чобіток на передню лапку ліву! Ось третій чобіток на задню лапку праву! А де ж четвертий чобіток - на задню лапку ліву? Куди подівся? Не має його на місці у передпокої! Як тепер бути? Без чобітка не можна на вулицу восени виходити! Гайда шукати!",
        "Де тільки не шукали! Бабуся-собачка вже не молода. Важко їй лазити попід диваном, попід стільцями й ліжками. А батьки Кетті на роботу пішли. Допомогти не можуть. «То, мабуть, прийдеться дома бути. Без прогулянки.- каже бабуся.- Бо надворі дощик і калюжі величезні! Чобітки, Кетті, на місце потрібно ставити! Щоб зразу взувати, а не півдня шукати. Час гаяти!»",
        "Засмутилося цуценятко. Бо дуже на прогулянку хоче побігти. То й почала Кетті знов чобіток загублений шукати! Принюхувалася, придивлялася, прислухалася. У всі закутки позаглядала і... знайшла чобіток! У дальному куточку під шафою.",
        "Зраділа Кетті. Покликала бабусю й почала одягатися, взуватися на прогулянку. Ось перший чобіток на передню лапку праву! Ось другий чобіток на передню лапку ліву! Ось третій чобіток на задню лапку праву! Ось четвертий чобіток на задню лапку ліву!» То й взулись! Пішли до парку.",
        "А коли повернулася маленька Кетті з прогулянки, помила свої чобітки. Поставила їх рівненько на звичне місце у передпокої. Щоб наступного дня не шукати та час не гаяти. Нехай на неї тут чекають! Бо чобітки теж прогулянку люблять.",
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
