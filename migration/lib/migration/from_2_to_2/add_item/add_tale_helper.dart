import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Мишеня Пік-Пік';

  @override
  Set<String> get extraTags => {};

  @override
  TaleCrewDto? _getCrew() => TaleCrewDto(
        authors: [83],
        readers: [83],
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
        "У великій мишачій родині жило собі та підростало маленьке мишеня. Звали його Пік-Пік, а інколи… сіреньким боягузом кликали. Бо мишенятко трішечки всього побоювалося. Та ось настав час йти йому до садочка для діток мишачих. Але не наважується полохливий Пік-Пік із нірки вийти.",
        "Узяла його матуся за лапку та говорить: «Зроби лише ОДИН крок у бік садочка, а ще… ще Чарівні слова вимовляй – сміливішим ставай!»",
        "Пропищало мишеня чарівні слова:",
        "«Маленьке мишенятко – сіренький карапуз!\nАле я не боюся, бо Я – не боягуз!\nВ дитсадочок я піду,\nдрузів гарних там знайду!»",
        "Зробило мишенятко один крок, вийшло з нірки. Дивиться: багато мишенят ідуть-біжать до садочка. Усі веселі, гомінкі! То й пішов Пік-Пік разом з мамою за ними.",
        "Прийшли вони до дитячого садочка. Але мишенятко розлучатися з матусею не бажає, боїться. Тоді мама й каже йому: «Залишся у садочку лише на ОДНУ годинку. Це не довго! Чарівні слова промовляй – сміливішим ставай!»",
        "Сказало мишеня чарівні слова:",
        "«Маленьке мишенятко – сіренький карапуз!\nАле я не боюся, бо Я – не боягуз!\nБуду у садочку з дітлахами гратись,\nБуду веселитись, стрибати, сміятись!\nПлине, плине час швиденько!\nПрийде матінка рідненька!»",
        "Вже сміливішим став Пік-Пік та й залишився в дитсадочку. Як цікаво тут! Скільки іграшок, скільки забав! Та ось покликала вихователька малечу на сніданок. Дивиться мишенятко, а в тарілці якась КАША. Нова, незнайома… Мама такої не готувала.",
        "Боязко маленькому Пік-Піку… А вихователька і каже: «А ти лише ОДНУ ложечку спробуй! ОДНУ – не страшно! А дуже смачно! Чарівні слова вимовляй – сміливішим ставай!»",
        "Сказало мишеня чарівні слова:",
        "«Маленьке мишенятко – сіренький карапуз!\nАле я не боюся, бо Я – не боягуз!\nСміливо ложку я беру,\nДо рота кашку я кладу!\nОдна ложка – смачно як!\nЗ`їв усе! Оце так Я!»",
        "Так і з`їв Пік-Пік усю кашу!",
        "Не помітило мишенятко, як час сплинув, та матуся за ним прийшла. А маленькому Пік-Піку додому йти не дуже хочеться. Бо сподобалося в садочку з іншими діточками-мишенятами гратись, забавлятись. Але ж додому час повертатися.",
        "Помахало мишенятко новим друзям лапкою на прощання та пообіцяло наступного дня прийти: «До завтра! До ранку! До нової зустрічі в дитячому садочку!»",
        "Наступного дня прокинулося мишенятко рано-вранці та й каже матусі:",
        "«Сміливе мишенятко – сіренький карапуз!\nНічого не боюся, бо Я – не боягуз!\nДобре вранці зустрічатись,\nВ дитсадочку з дітьми гратись!\nВідведи скоріш, матусю,\nБо чекають мене друзі!»",
        "То й пішов, пострибав Пік-Пік з радістю до дитсадочка! А матуся його на роботу усміхнена пішла.",
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
