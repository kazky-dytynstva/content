import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Вагончик Чих-Пих потоваришував з Годинником';

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
        "Жила-була собі родина Потягів. І жила вона у великому місті під назвою Залізничне Депо. Потрібно сказати, що у цьому місті мешкало багато інших родин. Жили вони дружньо, мирно та допомагали одна одній.",
        "У сім’ї Потягів підростав маленький Вагончик на ім’я Чих-Пих. Був він добрим, веселим, кмітливим та трішечки замріяним. Малюк Чих-Пих поблискував на сонці сталево-синім кольором, а жовті смужки на спинці робили його дуже симпатичним. А ще маленький Вагончик дуже любив мріяти.",
        "Дивлячись у блакитне небо, він спостерігав за пухнастими хмаринками і бачив у них казкові країни, величезні залізничні вокзали. А ще… а ще уявляв себе самого сильним спритним вагоном. Малюк мріяв та уявляв, як пасажири вітають його, шанують, дякують за роботу. Інколи, лежачи посеред квітучого садочка поряд з домом та зазираючи у бездонне небо, він уявляв себе потужним потягом! Всі навколо аплодують йому за швидкість! А іноді, побачивши в небі літак, Вагончик Чих-Пих мряів стати-працювати величезним надшвидким літаком. Начебто летить він вище за хмари, навіть обганяє вітер …",
        "Від таких думок замріяний Вагончик був у захваті. Та й забував, що йому потрібно робити… Якось забув допомогти бабусі у садку квіти полити, бо уявляв себе вантажним потягом, що везе квіти на свято до іншого міста. Безліч квітів: квіти в горщиках, у вазочках, у букетах. А інколи Чих-Пих, заміркувавшись, забував вранці ліжко своє застелити та вмитися. Бо… бо … мріяв бути справжнім височенним семафором на величезній залізничній станції. Щоб світити червоним та зеленим світлом швидким електричкам, які курсують у передмісті.",
        "Вся родина маленького Вагончика була дуже працьовитою. Татусь-кремезний товарний Потяг перевозив корисні вантажі та отримував вдячність від начальника Депо. Матуся- елегантна струнка Електричка допомагала пасажирам дістатися з одного міста до іншого. Інколи малюк Чих-Пих сумував за нею, бо заклопотана матуся часто бувала у відрядженнях. Старші брати Вагончика добре навчалися у спеціальній залізничній школі, бо вирішили стати поштовими потягами.",
        "А дідусем пишалася вся родина, бо він працював Вантажним Краном. Не вважаючи на свій солідний вік, він був сильним, усміхненим та справно завантажував на платформи, у товарні поїзди безліч речей. У любу погоду дідусь величезний Кран діяв: і в зимові холоди, і в літню спеку завантажував він зерно у спеціальні цистерни, щоб людям в різних містах було б з чого муку та хліб робити. Вантажив будівельні матеріали для будівництва будинків та лікарень. Автівки та навіть автобуси підіймав дідусь Вантажний Кран та обережно ставив на залізничні платформи.",
        "Вся родина справно працювала! А старенька бабуся Чих-Пиха поралася вдома-готувала обіди й вечері для великої родини. Іноді вона зітхала, коли замріяний Вагончик забував щось зробити чи допомогти їй: «Ох-ох! Маленький ледар!» Чих-Пих ображався, бо який же він ледацюга… якщо він хоче працювати, як дорослі! Та мріє бути корисним, потрібним. І йому ставало трішки сумно! Втім, бабуся любила маленького онука й сподівалася, що він піде до школи та всьому навчиться!",
        "І ось настав час йти Вагончику Чих-Пиху до школи, учнем ставати. Школа була неподалік, тому заклопотані батьки малюка, відвівши його декілька разів на уроки, вирішили надалі не проводжати маленького школяра: нехай самостійним росте!",
        "Була золотава осінь, сонечко ще тепленько пригрівало, легенький вітерець підганяв Вагончик до школи. А дивовижні біли хмаринки повільно танцювали на небі. Чих-Пих підвів голову й задивився у небо. Аж раптом побачив серед хмаринок неймовірний гелікоптер. «Ой! Який гарний, швидкий! Я теж хочу бути гелікоптером! Як стрімко він взлітає вгору, як спритно приземлюється!»- подумав замріяний Вагончик. Але тієї ж миті, сонячний промінчик полоскотав носика Чих-Пиху, засміявся і … і промовив:",
        "- Якщо хочеш кимось стати-\nГрамоту іди вивчати!\nЗамало мріяти!\nПотрібно діяти!",
        "Здивувався малий мрійник, відірвав погляд від блакитного неба та швиденько до школи побіг. Але … але по дорозі до школи, на вулицях стільки всього цікавого, незвичного! Оченята Чих- Пиха роздивлялися навкруги. Аж раптом, калюжа після вчорашнього дощу. Маленькі колеса Вагончика по калюжі хлюп-хлюп! Краплі у всі боки летять, на сонці блищать! А небо бездонне у калюжній воді віддзеркалюється. Малий учень сам собі пароплавом здається!",
        "- Пих-чих, хлюп-хлюп!\nЯ великий працелюб!\nОт би пароплавом стати\nі на морі працювати!\nШанувати мене будуть\nІ ніколи не забудуть!\n- знов замріявся Вагончик. І не помітив, як до школи запізнився!",
        "Вчитель Семафор Семафорович подивився на малого мрійника, похитав головою та й промовив:",
        "- Маленький учень Вагончик Чих-Пих,\nТи до школи вчасно не встиг!\nЩоб потягом великим стати,\nНа залізниці щоб працювати,\nЗамало мріяти!\nПотрібно діяти!",
        "Засмутився маленький Вагончик, пообіцяв приходити до школи вчасно. Але й наступного дня, задивився Чих-Пих, як дядечко Світлофор на перехресті працює, «червоним-жовтим-зеленим» кольорами керує та й замріявся. То й знов до школи запізнився…",
        "Соромно батькам Вагончика перед вчителем за свого малюка. От татусь і каже Чих-Пиху:",
        "- Якщо хочеш кимось стати-\nПотрібно грамоту вивчати!\nЗамало мріяти!\nПотрібно діяти!",
        "А літній мудрий дідусь Вантажний Кран, поміркував та й говорить:",
        "- Потрібно, щоб наш малий мрійник з годинником потоваришував. Зізнаюся чесно, коли був я малим, теж до школи запізнювався. Доки… доки мій дідусь мені надзвичайного помічника не подарував- Годинника!",
        "Витяг дідусь Вантажний Кран зі своєї кишені крихітний Годинник на сріблястому ланцюжку та й подарував Чих-Пиху:",
        "- Тримай дарунок, мій онучок!\nЦе- Годинник: до часу ключик!\nПомічник твій та добродій,\nБо завжди буде в нагоді.\nВсюди час тобі підкаже,\nЯк прибути вчасно скаже!\nБо замало в житті мріяти,\nПотрібно ВЧИТИСЬ- діяти!",
        "Потоваришував Вагончик Чих-Пих з Годинником. Поклав його обережно до своєї маленької кишеньки. Навіть пристебнув в глибині кишеньки сріблястий ланцюжок, що не загубити приятеля.",
        "А Годинник познайомив малого мрійника із цифрами на своєму циферблаті та зі стрілочками- помічницями. Навчив час розуміти та… час поважати, на зайве не витрачати. Іноді, коли маленький учень занадто довго розглядав пухнасті хмаринки в небі й уявляв себе великим, шанованим, видатним потягом, чи літаком, чи пароплавом, Годинник нагадував Чих-Пиху важливі слова:",
        "- Якщо хочеш кимось стати-\nПотрібно грамоту вивчати!\nЗамало мріяти!\nПотрібно діяти!",
        "І тоді Вагончик дякував приятелю за добру пораду і з радістю швиденько біг до школи! Бо зрозумів: справжній Потяг, Літак, Пароплав на грамоті розуміється та прибуває вчасно! Вчасно прибуває, без запізнень!",
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
