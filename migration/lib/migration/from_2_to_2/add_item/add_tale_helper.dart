import 'dart:io';
import 'dart:math';

import 'package:dto/dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Кіт-воркіт Котофей Котофейович';

  @override
  Set<TaleTag> get extraTags => {};

  @override
  CrewDto? _getCrew() => null;
      // CrewDto(
      //   authors: null,
      //   readers: null,
      //   musicians: null,
      //   translators: null,
      //   graphics: null,
      // );

  @override
  ChapterAudioDto? _getAudio({
    required int chapterIndex,
  }) {
    return null;
    final data = getAudioData(audioPath(chapterIndex));
    return ChapterAudioDto(
      size: data.size,
      duration: data.duration.inMilliseconds,
    );
  }

  @override
  List<String>? _getText() => [
        'Край лісу під горою жили в хатці старий зі старою. Не було в них ні корови, ні свинки, ані якої скотинки, а був один кіт — кіт-воркіт Котофей Котофейович. І був отой кіт жадібний та ненажерливий. То сметанку злиже, то масло з’їсть, то молоко вип’є, наїсться, нап’ється, ляже в куточок та нявчить:',
        '— Мало, мало, мені б оладочок та млинців, мені б маслених пирогів!',
        'Ото старий терпів, терпів та й не витерпів. Узяв кота, відніс у ліс та кинув:',
        '— Живи, Котофею Котофейовичу, як хочеш, іди куди знаєш!',
        'А Котофейович у мох зарився, хвостом укрився та й спить собі. От день минув — Котофейовичу їсти схотілося. А в лісі ні сметанки, ні молока, ні млинців, ані пирогів.',
        'Пішов кіт-воркіт по лісі — спина дугою, хвіст трубою, вуса щіточкою. А назустріч йому Лисиця Патрикіївна.',
        '— Ой, хто ж ти такий та з яких країн? Спина дугою, хвіст трубою, вуса щіточкою!',
        'А кіт спину вигнув, та двічі пирхнув, та вуса настовбурчив.',
        '— Хто я такий та з яких країв? З сибірських лісів, Котофей Котофейович.',
        '— Ходімо, любий Котофею Котофейовичу, до мене, лисоньки, в гості.',
        '— Ходімо.',
        'Привела його лисичка до себе додому, в свої хороми. Почала його пригощати: вона йому шинки, вона йому дичинки, два горобчики. А він:',
        '— Мало, мало, мені б оладочок та млинців, мені б масляних пирогів!',
        'От лисиця й каже:',
        '— Коте Котофейовичу, та як же мені тебе, такого ненажеру, нагодувати? Піду до сусідів по допомогу.',
        'Побігла лисиця лісом. А назустріч їй вовк.',
        '— Добридень, кумонько-лисичко, куди біжиш, чому поспішаєш?',
        '— Ой, не питай, не розпитуй мене, вовчику, бо ніколи мені.',
        '— Скажи, кумонько, що тобі треба, може, я допоможу?',
        '— Ох, вовчику-кумцю, приїхав до мене рідний братик з далеких країв, з сибірських лісів — Котофей Котофейович.',
        '— А чи не можна, кумасю, подивитися на нього?',
        '— Можна, вовчику, тільки він дуже сердитий. До нього без подарунка не підходь, враз шкуру здере.',
        '— А я, кумонько, йому барана притягну.',
        '— Барана йому мало! Ну та нехай вже так. Я його попрохаю, може, він до тебе й вийде.',
        'І побігла лисичка далі. От іде їй назустріч ведмідь.',
        '— Добридень, лисичко, добридень, кумонько! Ти куди біжиш, чому поспішаєш?',
        '— Ой, не питай, не розпитуй, Михайле Михайловичу, бо ніколи мені.',
        '— Скажи, кумонько, що тобі треба, може, я допоможу.',
        '— Ох, ведмедику, Михайле Михайловичу! Приїхав до мене рідний брат з далеких країв, з сибірських лісів — Котофей Котофейович.',
        '— А чи не можна, кумонько, подивитись на нього?',
        '— Можна, ведмедику, тільки він у мене дуже сердитий, хто не сподобається — одразу з’їсть. До нього без подарунка й не підходь.',
        '— Я йому бика принесу.',
        '— Отож! Тільки ж ти, ведмедику, бика під сосну, а сам на сосну, та тихо сиди. Бо він тебе з’їсть.',
        'Лисичка хвостиком майнула, тільки її й бачили. От на другий день вовк та ведмідь притягли до лисиччиної хати подарунки — барана і бика. Поклали під сосну та й давай сперечатись.',
        '— Іди, вовчище, сірий хвостище, кликати лисицю з братом! — каже ведмідь.',
        '— Та ні вже, ведмедику, йди сам, ти ж більший та товстіший, тебе з’їсти важче.',
        'Один за одного ховаються, йти не хочуть. Коли це біжить зайчик Куций Хвіст. Ведмідь до нього:',
        '— Стій!',
        'Спинився зайчик. Сам тремтить, зубами цокотить, оком коситься.',
        '— Іди, зайчику Куций Хвіст, до Лисиці Патрикіївни, скажи, що ми її з братом дожидаємо.',
        'Зайчик і побіг. А вовк боїться, тремтить, скавчить:',
        '— Михайле Михайловичу, заховай мене!',
        'Ведмідь його в кущі й заховав. А сам на сосну заліз на самий вершечок. От лисиця двері розчинила, на поріг ступила та й гукає:',
        '— Збирайтеся звірі лісові, великі та малі, подивіться, який гість із далеких країв, із сибірських лісів Котофей Котофейович!',
        'Побачив його ведмідь та й шепоче вовкові:',
        '— Тьху, яка звіринка, маленька та поганенька!',
        'А кіт побачив м’ясо та як стрибне, як почне м’ясо рвати та нявчати:',
        '— Мало, мало, мені б оладочок та млинців, мені б масляних пирогів!',
        'Ведмідь аж затрусився від жаху:',
        '— Ой лихо! Мале, та жадібне — бика йому замало! Хоч би мене не з’їв!',
        'Сидить ведмідь, тремтить, аж сосна хитається. Схотілося і вовкові на невиданого звіра глянути. Заворушився під кущем, а кіт подумав, що то миша. Як кинеться, як стрибне, кігті випустив!',
        'Вовк тікати! Кіт вовка побачив, злякався та плиг на сосну, а на сосні ведмідь.',
        '«Біда, — думає ведмідь, — вовка з’їв, до мене добирається!»',
        'Затремтів, затрусився та як гепнеться з дерева. А тоді навтьоки. А лисиця хвостиком крутить, їм услід кричить:',
        '— Він ще вам покаже! Він ще вас з’їсть!',
        'Отож з тої пори стали всі звірі кота боятися. Почали йому данину носити: хто сметанки, хто шинки, хто оладочок та млинців, а хто масляних пирогів. Так і став жити, лиха не знаючи, сірий кіт Котофей Котофейович!',
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

  String audioPath(int chapterIndex) => '${getTalePath(chapterIndex)}audio.mp3';

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

    final content = _getContent();
    final tags = <TaleTag>{
      if (content.first.text != null) TaleTag.text,
      if (content.first.audio != null) TaleTag.audio,
      if (crew?.authors?.isNotEmpty == true) TaleTag.author,
    }..addAll(extraTags);

    tale = TaleDto(
      id: nextId,
      name: taleName,
      createDate: DateTime.now().millisecondsSinceEpoch + createDateDelta,
      updateDate: null,
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

  CrewDto? _getCrew();

  /// Other than [Tags.author],[Tags.text],[Tags.audio]
  Set<TaleTag> get extraTags;

  List<ChapterDto> _getContent() => [
        _createChapter0(),
      ];

  ChapterDto _createChapter0() => ChapterDto(
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
