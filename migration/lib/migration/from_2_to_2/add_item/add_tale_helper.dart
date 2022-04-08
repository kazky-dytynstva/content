import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Сонячні млинці';

  @override
  Set<String> get extraTags => {};

  @override
  TaleCrewDto? _getCrew() => TaleCrewDto(
        authors: [79],
        readers: [79],
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
        "Одного літнього дня дівчинку Ганнусю відвезли на літні канікули батьки до бабусі Світлани. Дівчинка обожнювала проводити час у бабусі, адже там можна було поласувати улюбленими фруктами, знайти нових друзів, а головне – побути з бабусею. Машина під’їхала до бабусиної хатки, Ганнуся підбігла до бабусі і міцно-міцно обійняла її.",
        "– Бабусю, привіт, я так скучила за тобою.",
        "– Привіт, моя люба, – вигукнула бабуся й додала: як ти виросла! Я насмажила твоїх улюблених млинців із суничним варенням.",
        "– Ммм...",
        "– Гайда до столу.",
        "Уся родина вимила ретельно руки й сіла за стіл, де на них чекав смачний обід.",
        "Ганнуся добряче поласувала млинцями.",
        "– Дякую, бабусю, твої млинці найсмачніші. Чому вдома не виходять млинці такими смачними? – запитала дівчинка.",
        "– Тому що на свіжому повітрі уся їжа стає найсмачнішою, – сміючись додала бабуся.",
        "Легкий вітерець обвітрює їжу, сонечко лагідно світить своїми промінчиками, тому будь-яка страва набуває особливого смаку. Усі зачудовано слухали розповідь бабусі. Так й промайнули літні канікули Ганни: щодня вони з бабусею плавали у ставку, збирали овочі і фрукти, гралися . Настав час їхати додому. Наостанок бабуся дала онучці баночку духмяного суничного варення й родина рушила.",
        "Наступного ранку дівчинка попросила:",
        "– Мамо, насмаж мені млинців, будь ласка.",
        "– Залюбки!",
        "Матуся насмажила млинці, а Ганнуся мастила їх варенням. Тоді дівчинка взяла тарілочку, поклала туди млинець із варенням й виставила на підвіконня з відчиненим вікном. Коли млинець похолов, Ганнуся з’їла його.",
        "– Доню, смачно було?",
        "– Так, – сказала донька, – але йому не вистачає головного інгредієнта – свіжого повітря й теплих промінчиків сонця, – сміючись Ганнуся.",
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
