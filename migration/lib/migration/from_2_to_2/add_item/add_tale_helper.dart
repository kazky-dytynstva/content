import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Рибалки';

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
        "У лісі жила родина єнотиків: тато, мама і маленький синочок – Смугастик. Щонеділі Смугастик із татом ходили до річки рибалити.",
        "Але останнім часом хлопці поверталися додому з порожніми руками. Смугастик засмутився й сказав, що більше не піде на річку.",
        "І от настала неділя, час риболовлі.",
        "–Синочку, гайда разом ловити рибку! – погукав малого тато.",
        "– Ні, цього разу я залишусь вдома, мені там нудно, однак ми нікого не можемо піймати.",
        "– Та ходімо, відчуваю, що сьогодні ми впіймаємо велику рибу.",
        "Тато із сином приїхали на їхнє улюблене місце біля річки, розклали рибальські крісла, розібрали кошик з їжею, який їм дбайливо склала матуся, дістали вудочки й відерце для рибки. Минула година, а рибка так і не ловилася.",
        "– Татку, я геть занудився дивитися на порожнє відерце, збираймося додому.",
        "– Почекай, Смугастику, ще трохи.",
        "Аж раптом волосінь на вудці натяглася. Маленький єнотик аж вистрибнув із крісла й підбіг до батька. Нарешті тато дістав з води улов. Смугастик, із роззявленим ротом, дивився на створіння, яке раніше ніколи не бачив.",
        "– Татку, а що це? – запитав син.",
        "– Це мушелька. Вона вміє роззявляти ротика. Геть так, як у тебе зараз, – сміючись, сказав тато.",
        "– Я хочу побачити це! – почав плескати в долоньки Смугастик.",
        "Татко поклав мушельку під тепле сонячне проміння. Панцир нагрівся і поступово, просто на очах рибалок, мушля почала відкривати ротика, а з нього щось заблищало.",
        "– Татку! А це що таке блискуче?",
        "– Це перлина.",
        "– Перлина? А хто її туди поклав?",
        "– Її ніхто туди не клав. У мушельку потрапила піщинка, яка згодом перетворилася на перлину. Перли – це дорогоцінними прикрасами.",
        "– Татку, зробімо матусі подарунок!",
        "– Ну добре, – сказав татусь і обережно вийняв перлинку з ротика мушлі.",
        "Смугастик помив перлинку в річці, щоб та блищала ще більше. Тато зроби у перлинці отвори шилом, що її можна було нанизати на ниточку і носити на шиї. Дорогоцінну прикрасу для мами поклали в коробочку і вирушили додому.",
        "Біля будиночку на них вже чекала матуся.",
        "– Мамо-мамо, – радісно загукав Смугастик, – це тобі!",
        "В долоньках він простяг їй коробочку. Матінка відкрила її і побачила прикрасу з перлинкою.",
        "– Ми допоможемо тобі одягти це намисто,– мовив тато.",
        "– Неймовірний подарунок! Де ви його взяли? – вражено спитала мама.",
        "– Це наша велика рибальська пригода, – відповів Смугастик і підморгнув татові.",
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
