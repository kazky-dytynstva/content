import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Рученьки, ніженьки';

  @override
  Set<String> get extraTags => {
        Tags.poem,
        Tags.lullaby,
      };

  @override
  TaleCrewDto? _getCrew() => TaleCrewDto(
        authors: [_mykolaSom],
        readers: [_olgaTokar],
        musicians: [_oskarSandler],
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
        "Заходить за хмари зоря-зоряниця,",
        "І гомін стихає кругом,",
        "А місяць злітає, неначе жар-птиця,",
        "Над сонним і тихим вікном.",
        " ",
        "Рученьки-ніженьки, лагідні очі,",
        "Спокійної ночі, скінчилася гра.",
        "Рученьки-ніженьки, лагідні очі,",
        "Спокійної ночи, спати пора!",
        " ",
        "Хай сниться вам, діти, дідусева казка,",
        "В якої щасливий кінець.",
        "Хай татова сила і мамина ласка",
        "Іде до маленьких сердець.",
        " ",
        "Рученьки-ніженьки, лагідні очі,",
        "Спокійної ночі, скінчилася гра.",
        "Рученьки-ніженьки, лагідні очі,",
        "Спокійної ночи, спати пора!",
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
