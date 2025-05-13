import 'dart:io';
import 'dart:math';

import 'package:dto/dto.dart';
import 'package:migration/migration/from_3_to_3/add_item/add_tale_reading_time.dart';
import 'package:migration/migration/from_3_to_3/add_item/base_add_helper.dart';
import 'package:migration/migration/from_3_to_3/from_3_to_3.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From3to3 migration) : super(migration);

  @override
  String get taleName => 'Чарівна шишка';

  @override
  Set<TaleTag> get extraTags => {};

  @override
  CrewDto? _getCrew() {
    return null;
    return CrewDto(
      authors: null,
      readers: null,
      musicians: null,
      translators: null,
      graphics: null,
    );
  }

  @override
  AudioContentDto? _getAudioContent() {
    return null;
    final data = getAudioUtilData(audioPath());
    return AudioContentDto(
      fileSize: data.size,
      duration: data.duration.inMilliseconds,
    );
  }

  @override
  List<String>? _getText() => [
        "У самому серці зеленого лісу, серед високих дубів, сріблястих ялин і золотих кленів, жила маленька білочка на ім’я Белла. Вона мала пухнастий рудий хвіст, блискучі оченята й таке добре серце, що навіть найсуворіший старий борсук посміхався, коли бачив її. Белла була дуже допитливою, любила збирати горішки, вчилася пекти пироги з лісових ягід і завжди знаходила час, щоб допомогти сусідам. Але понад усе вона любила казки.",
        "Коли Белла була ще зовсім маленькою, вона жила зі своєю мамою в теплому дуплі в старому буку. Щовечора, коли за вікном шелестіли листя і ліс засинав, мама вкладала її до ліжечка з м’яких мохів і розповідала казки. Найулюбленішою була історія про чарівну шишку.",
        "Мама завжди починала її пошепки, наче це була велика таємниця. Вона розповідала, що десь у лісі росте особлива ялинка — темна, мов ніч, тиха, як снігова заметіль. І під цією ялинкою раз на сто років з’являється шишка, яка світиться зсередини. Ця шишка може виконати лише одне бажання — але не будь-яке, а тільки те, що йде від щирого серця. Того, хто подумає не тільки про себе, а про інших.",
        "— Але якщо бажання буде жадібним, — казала мама, — або егоїстичним, то шишка просто зникне. Вона не любить, коли її силу використовують нечесно.",
        "— А ти її бачила? — питала мала Белла, затамувавши подих.",
        "— Ні, моя люба. Але бачити не обов’язково. Головне — вірити.",
        "І кожного разу, засинаючи під мамині лагідні слова, Белла уявляла ту чарівну шишку. Вона мріяла про неї, як про щось надзвичайне і добре.",
        "Минали роки. Белла виросла. Мама переселилася до іншого дупла на південному узліссі, а Белла сама влаштувала затишне житло в дуплі старого дуба. Вона навчилася запасати горіхи, готувати смачний чай, прибирати у домі й навіть допомагати іншим звірятам з ремонтом хаток. Але хоч би скільки зими пройшло, Белла ніколи не перестала вірити в ту чарівну шишку з маминої казки.",
        "Одного ранку, коли осінь тільки починала вкривати ліс золотом, Белла вирушила на прогулянку. Вона йшла знайомою стежкою, з кошиком через плече, збираючи жолуді та ожину. Все було, як завжди, аж раптом її погляд зупинився на ялинці, яку вона ніколи раніше не бачила.",
        "Вона стояла осторонь, сама, на невеликій галявині. Її гілки були густі, голки темніші, ніж у звичайних ялин, а сама вона, здавалося, дихала спокоєм. Повітря навколо неї було тихим і чистим, немов увесь ліс завмер.",
        "Під цією ялинкою Белла побачила щось незвичайне. Шишка. Вона лежала прямо посеред моху, рівно, ніби її хтось поклав туди навмисне. І вона світилася. М’яке золотисте світло пульсувало всередині, ніби в неї билося маленьке серце.",
        "Белла завмерла. Її дихання перехопило. Вона зробила крок уперед, потім ще один, і нахилилась. Шишка була теплою на дотик, не колола, а навпаки — неначе пригорнула її лапки.",
        "— Це вона... — прошепотіла Белла. — Чарівна шишка.",
        "Вона обережно поклала її в кошик і побігла додому. Її серце билося швидко, наче в неї всередині співала ціла зграя пташок. Але водночас їй було трохи тривожно.",
        "Повернувшись, вона довго дивилася на шишку. Нарешті, майже несміливо, прошепотіла:",
        "— Хотіла б я мати більше місця в коморі для своїх запасів...",
        "І щойно вона це сказала, в її дуплі з’явилася нова поличка, точно така, як вона уявляла. Белла не повірила очам. Шишка справді виконувала бажання.",
        "Проте, згадуючи мамині слова, вона вирішила порадитися з Совою Софією — наймудрішою істотою лісу.",
        "— Сова Софіє, — звернулась Белла, — я знайшла чарівну шишку. Вона справжня. Я загадала бажання — і поличка з’явилася! Але тепер не знаю, що з нею робити...",
        "— Справжня сила — це відповідальність, — відповіла Совія. — Якщо ти можеш змінити щось чарівним чином, це ще не означає, що маєш це робити. Ліс — це складна система. Те, що здається поганим або зайвим, часто потрібно для рівноваги.",
        "Наступні дні до Белли почали приходити друзі. Першим з’явився зайчик Тимко.",
        "— Белло, я чув про шишку... Можеш загадати бажання, щоб я бігав так швидко, що мене навіть вітер не наздоганяв? Я б тоді вигравав усі змагання.",
        "Потім з’явилася їжачиха Грушка.",
        "— Мені важко товаришувати. Я сором’язлива, колюча... Можеш зробити так, щоб усі мене любили, як тільки бачать?",
        "Після неї прийшло лисеня Міла.",
        "— Я хочу, щоб усі мене слухали! Щоб у всіх було бажання робити те, що я скажу!",
        "Згодом приходили ще й інші — ховрах, який хотів знайти найбільший горіх у світі, жабка, яка мріяла стати співаком, хоча й квакала фальшиво, а навіть синичка просила вічного літа, бо не любила сніг.",
        "Усі щиро просили. Усі хотіли чогось для себе.",
        "Белла вагалась. Її серце стискалось від тривоги.",
        "Вона знову пішла до Софії.",
        "— Усі хочуть, щоб світ змінювався заради них. Я не знаю, як правильно...",
        "Софія мовчки дивилася на неї, потім сказала:",
        "— Те, що ми хочемо, не завжди те, що нам потрібно. Іноді ліс вчить нас чекати. Іноді — втрачати. Але саме це робить нас сильнішими. Чари — це випробування. Якщо ти справді хочеш зробити добро — запитай себе, для кого воно.",
        "Того вечора, не витримавши, Белла знову взяла шишку й прошепотіла:",
        "— Я хочу, щоб зима не приходила. Щоб усім було тепло. Щоб ніхто не мерз і не голодував…",
        "Шишка яскраво спалахнула — і стало літо.",
        "Але ліс став іншим. Квіти не відпочили — і зів’яли. Річки міліли. Комахи розмножувалися без перерви, і птиці не мали коли гніздуватися. Ведмеді були змучені, бо не могли спати. Ліс втратив ритм.",
        "Белла побігла до Софії.",
        "— Я зіпсувала все... Я ж хотіла як краще...",
        "— А стало гірше, — м’яко сказала Софія. — Ти хотіла позбавити всіх болю, не давши їм пройти шлях. Але біль — це теж частина життя. Як і зима. Без зими немає весни.",
        "— Як же все виправити?",
        "Софія нахилила голову.",
        "— Послухай серце. Якщо справді навчилася бачити більше, ніж себе — шишка почує тебе.",
        "І Белла зрозуміла.",
        "Вона повернулася додому, взяла шишку й мовила:",
        "— Я хочу, щоб ліс був у гармонії. Щоб усе повернулось, як має бути. Щоб усі ми вчилися бути добрішими не через магію, а через щире серце.",
        "Шишка засвітилася ще раз. Потім — розсипалась на золотий пил і розтанула у повітрі.",
        "Зима прийшла м’яко. Усі були готові. Кожен мав запаси, затишне житло, і всередині — розуміння.",
        "Того вечора всі зібралися у Белли. Вона пригощала чаєм з ожини, усміхалась, а в очах світилась тиха радість.",
        "Софія подивилась на всіх і сказала:",
        "— Мудрість — не в тому, щоб змінити світ під себе. А в тому, щоб побачити в ньому сенс. Ми всі різні. Ми всі хочемо тепла, радості, легкості. Але щастя не завжди приходить одразу. Іноді щастя — це шлях.",
        "\n***\n",
        "З того часу Белла більше не шукала чарів. Вона збагнула: не в шишці була сила, а в її виборі. Відтоді вона жила простим, але повним життям — збирала горішки, пекла пироги, допомагала сусідам і вже не прагнула змінити світ. Вона навчилася любити його таким, яким він є.",
        "Минали роки. І одного дня в її дуплі з’явилися маленькі пухнасті хвостики — її власні білченята.",
        "Щовечора, коли ліс повільно засинав, Белла вкладала своїх малюків у м’яке ліжечко з моху, і, як колись її мама, починала пошепки:",
        "— Десь у лісі росте темна ялинка. Під нею раз на сто років з’являється чарівна шишка…",
        "— А ти її бачила? — питали білченята, широко розплющивши очі.",
        "Белла усміхалась і відповідала:",
        "— А хто знає… Може, це й казка. А може — ні. Але головне не в тому, чи вона була справжня. А в тому, що ми з вами завжди можемо бути тими, хто робить добро — без чарів.",
        "Бо кожне щире серце — трошечки чарівне.",
        "І в затишному дуплі, серед тепла, спокою й любові, нова історія починала своє життя — історія, що народилась не з магії, а з мудрості."
      ];

  @override
  String get summary =>
      'У глибокому лісі маленька білочка знаходить чарівну шишку, що виконує бажання. Випробування, які на неї чекають, допомагають зрозуміти, що справжня сила — у щирості, добрі й мудрості серця.';
}

abstract class _AddTaleHelper extends BaseAddHelper {
  _AddTaleHelper(From3to3 migration)
      : super(
          migration,
          addItemName: 'Tale',
          folderName: 'tales',
        );

  final spaceRegExp = RegExp(r"\s{2,}");
  late TaleDto tale;

  String getTalePath() => '$dataPath/$nextId/';

  String audioPath() => '${getTalePath()}audio.mp3';

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

      final path = getTalePath();
      final dir = Directory('${path}img');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
        migration.log('Empty folder for tale was created');
        throw Exception('Please add some content to the tale folder');
      }

      if (post) {
        final imageFile = File('${path}img/0.jpg');
        assert(
          imageFile.existsSync(),
          'Image for the tale was not found',
        );

        if (tale.tags.contains(TaleTag.audio)) {
          final audioFile = File('${path}audio.mp3');
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
    final list = json.map((e) => TaleDto.fromJson(e)).toList();
    if (originalList.isEmpty) {
      originalList.addAll(list);
    }
    return list;
  }

  Future<int> _getLastId() async {
    final people = (await getAll()).map((e) => e.id);
    return people.reduce(max);
  }

  @override
  Future<void> add() async {
    final createDateDelta = const Duration(days: 1).inMilliseconds;

    final crew = _getCrew();

    final audio = _getAudioContent();
    final text = _textContentDto();

    final tags = <TaleTag>{
      if (text != null) TaleTag.text,
      if (audio != null) TaleTag.audio,
      if (crew?.authors?.isNotEmpty == true) TaleTag.author,
    }..addAll(extraTags);

    tale = TaleDto(
      id: nextId,
      name: taleName,
      createDate: DateTime.now().millisecondsSinceEpoch + createDateDelta,
      updateDate: null,
      summary: summary,
      tags: tags,
      text: text,
      audio: audio,
      crew: crew,
      ignore: null,
    );

    final all = await getAll();
    all.add(tale);
    await saveJson(all);
  }

  String get taleName;

  String get summary;

  CrewDto? _getCrew();

  /// Other than [Tags.author],[Tags.text],[Tags.audio]
  Set<TaleTag> get extraTags;

  TextContentDto? _textContentDto() {
    final text = _getText();
    if (text == null) return null;

    final readingTimeHelper = AddTaleReadingTime();

    final readingTime = readingTimeHelper.getReadingTime(
      paragraphs: text,
    );

    return TextContentDto(
      paragraphs: text,
      minReadingTime: readingTime.minimum,
      maxReadingTime: readingTime.maximum,
    );
  }

  AudioContentDto? _getAudioContent();

  List<String>? _getText();
}

const int _mariaVoznyak = 91;
const int _anhelinaRatushenko = 89;
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
const int _ivanFranko = 38;
const int _stepanRudanskyj = 37;
const int _leonidGlibov = 36;
const int _bratyGrim = 35;
const int _marijkaPidgiryanka = 34;
const int _myhailoStelmah = 33;
const int _valentynaYurchenko = 32;
const int _serhijTatienko = 31;
const int _mykolaSygnaivskyj = 30;
const int _irynaKyrylina = 29;
const int _dmytroPavlychko = 28;
const int _andrijMalyshko = 27;
const int _platonMajboroda = 26;
const int _nataliyaZabila = 25;
const int _annaSereda = 24;
const int _grygorijBojko = 23;
const int _marijaHorosnytska = 22;
const int _anatolijKosteckyj = 21;
const int _samuilMarshak = 20;
const int _ivanMalkovych = 19;
const int _pavloGlaovyj = 18;
const int _valentynaBajkova = 17;
const int _anatolijGrygoruk = 16;
const int _yulianTuvim = 15;
const int _vasylChuhlib = 14;
const int _yanikaTereshenko = 13;
const int _viktorPavlik = 12;
const int _jannaHoma = 11;
const int _liliyaGudz = 10;
const int _tetanaLeonteva = 9;
const int _yuliaZadorojna = 8;
const int _katerynaGavrylova = 7;
const int _mariyaSoltysSmyrnove = 6;
const int _galynaMyroslava = 5;
const int _innaYavorska = 4;
const int _vasylSuhomlynskyi = 3;
const int _oksanaKrotyuk = 2;
const int _gansAndersen = 1;
const int _lesyaUkrainka = 0;
