import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Найкращий подарунок для мами';

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
        "Діло було весною у дітсадочку для звіряток. Маленького совенятка Філю вранці сюди привів дідусь поважний Філін. Бо матуся совеня працювала. Зазвичай Філя був веселим, привітним, жвавим. Але сьогодні малюк прийшов похмурим, засмученим. Він скучав за мамою. А ще … ще він не знав, що подарувати мамі на весняне свято. Тим часом у дитсадочку маленькі звірята малювали: готували сюрпризи до Свята МАТУСЬ.",
        "Совеня Філя підійшов до свого приятеля веселого Їжачка, привітався й запитав:",
        "- Їжачок, що подарувати мамі? Який подарунок буде найкращим?",
        "Їжачок зрадів другові, привітався та показав свій малюночок:",
        "- Я подарую матусі смачні гриби, бо вона їх дуже любить. Збирає в лісі та смачно готує.",
        "«Може й моїй мамі гриби подарувати?- міркує Совеня.-",
        "Смачні гриби! Гарний малюнок!\nТа чи найкращий це подарунок?!»",
        "То й пропонує Їжачкові: «Ходімо у звірят запитаємо».",
        "Пішли вони разом по дитсадочку. Ось Руденька Білочка. Запитали в неї, який подарунок найкращім для матусі буде.",
        "- Я подарую мамі хрумкі горішки, бо вона їх дуже любить. На ліщині збирає, взимку зберігає, всіх пригощає.",
        "«Може й моїй мамі горіхи подарувати?- міркує Совеня.-",
        "Хрумкі горішки! Гарний малюнок!\nТа чи найкращий це подарунок?!»",
        "- Ходімо запитаємо!",
        "То й пішли разом дізнаватися Совеня, Їжачок і Білочка. Бачать: маленьке сіре Мишенятко. То й запитують у нього:",
        "- Мишеня! Який подарунок буде найкращим? Що подарувати мамі?",
        "- Моя матуся сир любить! - показує сіренький малюк свій малюночок. А на ньому величезний шматок сиру.- Матуся сир смачний готує та всю родину пригощає!",
        "«Може й моїй мамі сир подарувати?- міркує Совеня.-",
        "Духмяний сир! Гарний малюнок!\nТа чи найкращий це подарунок?!»",
        " - Ходімо запитаємо!",
        "То й пішли далі дізнаватися Совеня, Їжачок, Білочка і Мишеня. Побачили: Зайченя матусі морквиночку приготувало, маленький горобчик- насіннячко, а козеня- букет із сіна й соломи. Вийшли на прогулянку з вихователькою тітонькою Корівонькою. Вона усміхається: дорослішають звірятка! Дружні, допитливі! Хочуть найкращі подарунки матусям зробити!",
        "Бачать звірятка: на небі маленька Хмарка-донька біля великої",
        "Хмарини-матінки. Вередує мала, аж дощ пішов!",
        "- Хмаринко, привіт!- голосно промовив совенятко Філя.- А який подарунок ти приготувала своїй матусі до свята?",
        "Здивувалася маленька Хмаринка, бо про свято не знала. Аж вередувати й плакати перестала. То й дощик скінчився! Подумала хмаринка та й каже:",
        "- Я подарую матусі свою усмішку та слухняність. Ще парасольку намалюю. Вони їй подобаються.",
        "Усміхнулася хмаринка мамі - великій хмарині. Сказала, як її любить. Зраділа матуся Хмара! Та й пішли вони небом за обрій, за своїми справами. А тепле сонечко, що за хмарами сховане було, визирнуло. Небо чистим весняним стало.",
        "Запитують звірята:",
        "- Сонечко, який подарунок буде найкращим для матусі?",
        "Усміхнулося сонечко лагідно та й відповідає:",
        "- Кожна мама зрадіє малюночку! Бо це руками її рідної дитини зроблено! З турботою та любов'ю! Але є секрет: до подарунка додайте свою веселу усмішку, доброту й слухняність! То ж подарунок найкращим і стане!",
        "- Так, я зрозумів! – весело сказав совенятко Філя.- Я подарую мамі Сові щиру усмішку, обійми та чарівний усміхнений ліхтарик! Нехай він яскраво світить в ночі! Допомагає матусі, коли вона працює - ліс охороняє!",
        "Намалював совенятко Філя чарівний ліхтарик з веселою усмішкою.",
        "І почав свято чекати. Бо тепер і у нього є найкращій подарунок для мами!",
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
