import 'dart:io';
import 'dart:math';

import 'package:dto/dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Як зайченята до Великодня готувалися';

  @override
  Set<TaleTag> get extraTags => {};

  @override
  CrewDto? _getCrew() => CrewDto(
        authors: [_mariaVoznyak],
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
        'Був теплий весняний ранок. Все потроху почало прокидатися після довгої та холодної зими. Дзюрчали перші струмочки, а ліс наповнювався дивовижним запахом квітів. Мама-зайчиха клопоталася на кухні, а потім вирушила збирати гриби та ягоди для своєї сім’ї. Та ось лихо: дорогою її застав дощ. Парасольки зайчиха, звісно, не мала, тому вона повністю промокла і захворіла. Тато-зайчик дуже засмутився через це, а разом з ним і зайченятка, адже наближалося велике свято — Великдень. Як же вони будуть готуватися без мами?',
        'Напевно, ви, любі читачі, знаєте, що в цей особливий день зайчик приносить діткам різнокольорові яєчка-писанки. А їх вони варять і фарбують разом із зайчихою. Тато-зайчик сидів біля своєї дружини на дивані і гірко плакав. Побачивши це, зайченята вирішили врятувати свято. Та перед ними постало запитання: «Де взяти яєчка?»',
        'Одне з зайченят промовило:',
        '— Можемо піти до курника поблизу лісу.',
        '— Так, думаю, це чудова ідея, — відповіло інше. — Побігли!',
        'Довго вони бігли, чи ні — нікому не відомо. Та раптом їм на зустріч йде півник.',
        '— Що ви тут робите? — запитав він зайченят. — Навіщо прибігли?',
        'Вони все йому розповіли. А півник сказав:',
        '— Якщо треба, то треба. Йдіть до курочки Маї, вона дасть вам все, що потрібно.',
        'Зайченята зраділи та чимдуж побігли до курочки. Вона ретельно підібрала для них найкращі яєчка для писанок і віддала. Малюки подякували їй і почимчикували додому.',
        'Прибувши до оселі, зайченята почали прибирати хатинку. Через деякий час усе блищало від чистоти. Побачивши це, тато-зайчик і мама-зайчиха сказали:',
        '— Які ви у нас молодці, вже зовсім дорослі зайчики стали!',
        'Пізніше зайчиха повністю одужала і разом зі своїми малюками спекла неймовірно смачні пасочки. Коли настало свято, тато-зайчик зібрав повний кошик писанок і попрямував розносити подарунки діткам. А коли повернувся додому, всі сіли за святковий стіл. Зайченята були дуже раді, бо батьки пишалися ними, і свято було врятовано.',
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
