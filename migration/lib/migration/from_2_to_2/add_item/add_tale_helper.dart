import 'dart:io';
import 'dart:math';

import 'package:dto/dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Найвеличніше свято лісу';

  @override
  Set<TaleTag> get extraTags => {};

  @override
  CrewDto? _getCrew() => CrewDto(
        authors: [_anhelinaRatushenko],
        readers: null,
        musicians: null,
        translators: null,
        graphics: null,
      );

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
        'Було колись у лісі чарівна дружба чотирьох тварин – вовка, зайчика, білочки та хом\'яка. Наближалось Різдво, і вони вирішили приготувати найвеличніше свято для всього лісу.',
        'Вовк, який завжди був кулінарним володарем, взяв на себе головне завдання – готування смачних страв. Він роздумував про особливий суп, який підніме настрій усім лісовим мешканцям.',
        'Заєць вирішив прикрасити ліс величезною гірляндою з ялинкових гілочок, а білочка збирала найсмачніші горішки для святкових страв. Хом\'як же допомагав влаштувати затишні гнізда для всіх тварин, щоб вони могли насолоджуватися теплом у цей святковий період.',
        'І ось, на день перед Різдвом, коли вони вже прикрашали ялинку, раптом на їхньому порозі з\'явився святий Миколай. Всі тварини були вражені та радісно вигукнули: "Святий Миколаю, ласкаво просимо! Ми готуємось до Різдва і сподіваємося, що ви приєднаєтеся до нашого святкового столу!"',
        'Святий Миколай сказав:',
        '- Дякую вам, мої добрі друзі! Я бачу, що у вас тут справжнє чарівне свято. Нехай ваше Різдво буде наповнене теплом, радістю та найсмачнішими стравами.',
        'І так, всі разом вони насолоджувалися смачним обідом.',
        'Святий Миколай сказав:',
        '- Хто хоче подарунок, той повинен розказати для мене віршик!',
        'Вовк підвівся перший:',
        '- Мій святенький Миколаю,\n'
            'Приходи скоріш, благаю.\n'
            'Я до тебе помолюся\n'
            'І тихенько пригорнуся.\n'
            'Щастя дай моїй родині\n'
            'І коханій Україні!',
        '-Дуже гарно! Молодець! Ось тобі за це подарунок! - сказав Миколай подаючи вовку великий подарунок.',
        '- Дякую вам! - сказав сідаючи на своє місце вовк.',
        '- Тепер я! - сказав хом\'як:',
        '-Від святого Миколая\n'
            'Я даруночка чекаю,\n'
            'Не стулю всю нічку очі,\n'
            'Бо який він знати хочу.',
        '- Але ж ти мене бачиш?',
        '- Так, так Святий Миколаю! Я дуже радий через це!',
        '- Я теж радий дарувати тобі подарунок! - мовив Миколай і подав подарунок хом\'ячку.',
        '- Дякую!',
        '- Будь ласка! Хтось ще хоче подарунок?',
        '- Так, ще я. - сказала білочка і почала:',
        '-Через поле, через гай\n'
            'Йде до діток Миколай.\n'
            'У білесенькій торбинці\n'
            'Він для всіх несе гостинці.',
        '-Тримай подарунок! Молодець! Сказав Миколай.',
        'Тільки заєць сидів і сумно опустив голову...',
        '- Чому ти сумуєш? - запитали звірятка.',
        '- Я не вивчив вірш... - сказав зайчик і заплакав.',
        '- Не плач, ми з тобою поділимося! - сказала білочка.',
        '- А ти себе добре вів у цьому році? -запитав святий Миколай.',
        '- Так! - закивав головою заєць.',
        '- Добре, тільки через це ти отримаєш подарунок! - даючи подарунок сказав Миколай.',
        '- Щиро дякую вам, дідусю!',
        'Миколай попрощався з тваринками і зник.',
        'Так звірята готувалися до Різдва і згадували про цю розповідь ще багато років.',
      ];

  @override
  String get summary => 'Lalala';
}

abstract class _AddTaleHelper extends BaseAddHelper {
  _AddTaleHelper(From2to2 migration)
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

    return TextContentDto(
      text: text,
      minReadingTime: 1,
      maxReadingTime: 2,
    );
  }

  AudioContentDto? _getAudioContent();

  List<String>? _getText();
}

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
