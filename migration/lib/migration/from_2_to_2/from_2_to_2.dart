import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/person/person_dto.dart';
import 'package:migration/migration/from_0_to_1/dto/_new/tale/chapter/audio/dto.dart';
import 'package:migration/migration/from_0_to_1/dto/_new/tale/chapter/dto.dart';
import 'package:migration/migration/from_0_to_1/dto/_new/tale/crew/dto.dart';
import 'package:migration/migration/from_0_to_1/dto/_new/tale/dto.dart';
import 'package:migration/utils/audio_util.dart';
import 'package:migration/utils/tale_tags.dart';
import 'package:migration/utils/to_json.dart';

import '../base_migration.dart';

class From2to2 extends BaseDataMigration {
  @override
  int get appBuildNumberOld => 149;

  @override
  String get appVersionOld => '5.0.0';

  @override
  int get dataVersionOld => 2;

  @override
  int get dataVersionNew => 2;

  @override
  bool get canCleanNewDirectory => false;

  @override
  Future<bool> migrate() async {
    final addPersonOk = true ?? (await _AddPersonHelper(this).run());
    final addTaleOk = true ?? await _AddTaleHelper(this).run();
    return addPersonOk && addTaleOk;
  }
}

abstract class _AddHelper {
  final From2to2 migration;

  final String addItemName;
  final String folderName;

  late int nextId;

  _AddHelper(this.migration, this.addItemName, this.folderName);

  final List<ToJson> originalList = [];

  String get dataPath => '${migration.dataPathOld}/$folderName';

  String get jsonPath => '$dataPath/list.json';

  Future<bool> run() async {
    migration.log('Add new $addItemName started ⏱');
    migration.log('   - pre validation started');
    assert(await validate());
    migration.log('   - pre validation done');
    await add();
    migration.log('   - add item - done');
    migration.log('   - post validation started');
    final addOk = await validate(post: true);
    if (addOk) {
      migration.log('   - post validation done');
      migration.log('New $addItemName was added successfully ☑️');
    } else {
      migration.log('   - post validation failed');
      await revert();
      migration.log('   - changes reverted');
      migration.log('New $addItemName was NOT added successfully 🛑️');
    }
    return addOk;
  }

  Future<void> add();

  Future<bool> validate({bool post = false});

  Future<void> revert() async {
    await saveJson(originalList);
  }

  Future<void> saveJson(List<ToJson> list) async {
    list.sort((a, b) => b.id.compareTo(a.id));
    final json = list.map((e) => e.toJson()).toList();
    await migration.saveJsonListToFile(data: json, filePath: jsonPath);
  }
}

class _AddPersonHelper extends _AddHelper {
  _AddPersonHelper(From2to2 migration) : super(migration, 'Person', 'people');

  @override
  Future<bool> validate({
    bool post = false,
  }) async {
    try {
      final all = await _getAll();

      final idList = all.map((e) => e.id).toSet();
      final nameList = all.map((e) => e.name).toSet();

      assert(
        idList.length == nameList.length,
        'Looks like we have duplicate',
      );

      if (post) {
        final path = '$dataPath/img/$nextId.jpg';
        final file = File(path);
        assert(
          file.existsSync(),
          'Image for the person was not found',
        );
      }
      return true;
    } catch (e) {
      migration.log(e.toString());
      return false;
    }
  }

  @override
  Future<void> add() async {
    nextId = (await _getLastId()) + 1;

    final person = PersonDto(
      id: nextId,
      name: 'Ніка Балаж',
      info:
          'Ілюстратор дитячого періодичного видання «Перший інтерактивний журнал для дітей Чарівний ліхтарик»',
    );
    final allPeople = await _getAll();
    allPeople.add(person);
    await saveJson(allPeople);
  }

  Future<List<PersonDto>> _getAll() async {
    final json = await migration.readJsonList(jsonPath);
    final people = json.map((e) => PersonDto.fromJson(e)).toList();
    if (originalList.isEmpty) {
      originalList.addAll(people);
    }
    return people;
  }

  Future<int> _getLastId() async {
    final people = (await _getAll()).map((e) => e.id);
    return people.reduce(max);
  }
}

class _AddTaleHelper extends _AddHelper {
  _AddTaleHelper(From2to2 migration) : super(migration, 'Tale', 'tales');

  late TaleDto tale;

  String getTalePath(int chapterIndex) => '$dataPath/$nextId/$chapterIndex/';

  @override
  Future<bool> validate({bool post = false}) async {
    try {
      final all = await _getAll();

      final idList = all.map((e) => e.id).toSet();
      final nameList = all.map((e) => e.name).toSet();

      assert(
        idList.length == nameList.length,
        'Looks like we have duplicate',
      );

      if (post) {
        final chapterIndex = 0;
        final path = getTalePath(chapterIndex);
        final dir = Directory(path + 'img');
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
          migration.log('Empty folder for tale was created');
          throw Exception('Please add some content to the tale folder');
        }

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

  Future<List<TaleDto>> _getAll() async {
    final json = await migration.readJsonList(jsonPath);
    final people = json.map((e) => TaleDto.fromJson(e)).toList();
    if (originalList.isEmpty) {
      originalList.addAll(people);
    }
    return people;
  }

  Future<int> _getLastId() async {
    final people = (await _getAll()).map((e) => e.id);
    return people.reduce(max);
  }

  @override
  Future<void> add() async {
    final createDateDelta = const Duration(days: 1).inMilliseconds;
    nextId = (await _getLastId()) + 1;

    final crew = _getCrew();

    final content = _getContent();
    final tags = <String>{
      if (content.first.text != null) Tags.text,
      if (content.first.audio != null) Tags.audio,
      if (crew?.authors?.isNotEmpty == true) Tags.author,
      // Tags.lullaby,
      Tags.poem,
    };

    tale = TaleDto(
      id: nextId,
      name: 'Зозуля й півень',
      createDate: DateTime.now().millisecondsSinceEpoch + createDateDelta,
      tags: tags,
      content: content,
      crew: crew,
    );

    final all = await _getAll();
    all.add(tale);
    await saveJson(all);
  }

  TaleCrewDto? _getCrew() => TaleCrewDto(
        authors: [36],
        readers: null,
        musicians: null,
        translators: null,
        graphics: null,
      );

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
  }) {
    return null;
    final path = getTalePath(chapterIndex) + 'audio.mp3';
    final data = getAudioData(path);
    return ChapterAudioDto(
      size: data.size,
      duration: data.duration.inMilliseconds,
    );
  }

  List<String>? _getText() => [
        "— Як ти співаєш, Півне, веселенько...",
        "— А ти, Зозуленько, ти, зіронько моя,",
        "Виводиш гарно так і жалібненько,",
        "Що іноді аж плачу я...",
        "Як тільки що почнеш співати,",
        "Не хочеться й пшениченьки клювати,-",
        "Біжиш в садок мерщій...",
        "— Тебе я слухала б довіку, куме мій,",
        "Аби б хотів співати...",
        "— А ти, голубонько, ти, кралечко моя,",
        "Поки співаєш на калині,",
        "То й весело мені, і забуваю я",
        "Свою недоленьку, життя своє погане",
        "Та безталанне...",
        "А тільки замовчиш",
        "Або куди летиш,-",
        "Заниє серденько, неначе на чужині...",
        "І їстоньки — не їм, і питоньки — не п'ю",
        "Та виглядаю все Зозуленьку мою.",
        "Як гляну на тебе — така ти невеличка,",
        "Моя перепеличко,",
        "А голосочок-то який!..",
        "Тонесенький, милесенький такий...",
        "Куди той соловей годиться?",
        "— Спасибі, братику, за добреє слівце.",
        "Як не кохать тебе за це?..",
        "І ти виспівуєш, неначе та жар-птиця;",
        "І далебі, що так,— пошлюся я на всіх.-",
        "Де взявся Горобець, підслухав трохи їх",
        "Та й каже: — Годі вам брехати",
        "Та одно другого знічев'я вихваляти! —",
        "Пурхнув — та й був такий.",
        " ",
        "За що ж,— хто-небудь попитає,-",
        "Зозуля Півня вихваляє?",
        "За те, що Півень годить їй",
        "Та потакати добре вміє:",
        "Рука, як кажуть, руку миє.",
      ];
}
