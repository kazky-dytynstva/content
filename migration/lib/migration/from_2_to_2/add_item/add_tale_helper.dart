import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Патрон - собака-рятувальник';

  @override
  Set<String> get extraTags => {};

  @override
  TaleCrewDto? _getCrew() => TaleCrewDto(
        authors: [11],
        readers: null,
        musicians: null,
        translators: null,
        graphics: [80],
      );

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
        "На перший погляд, Патрон — звичайнісінький собака, породи джек-расел тер'єр: маленький, спритний та дуже енергійний. Він повсякчас любить ганяти м'яча, вигрівати на сонечку спинку та гризти старі капці. А ще він шаленіє від сиру! Сир — це справжня винагорода для Патрона, який несе службу!",
        "Так-так! Не дивлячись на те, що Патрон такий малий, служба у нього важлива! Завдяки гострому нюху та спритним лапкам, Патрон може знайти та знешкодити будь-яку небезпечну річ!",
        "Одного разу, гуляючи на дитячому майданчику, двоє хлопчаків помітили біля пісочниці дивний предмет. Він був схожий чи то на залізний капелюх, чи то на корабель інопланетян, що застряг серед пустелі.",
        "— Що це? — підійшов до пісочниці Марко.",
        "— Не знаю, друже, але гадаю, що нам не варто це чіпати!",
        "— Мама казала, що невідомі предмети не можна піднімати із землі, адже це небезпечно!",
        "Враз Патрон, який у цю мить прогулювався поруч, розвідуючи місцину, почув розмову двох друзів.",
        "— Не чіпайте! ГАВ-ГАВ-ГАВ! — підстрибнув від страху пес.",
        "— Хто це? — здивувались товариші.",
        "— Я Патрон! Собака-рятувальник. А річ, яку ви побачили, вкрай небезпечна, адже вона може вибухнути! Тож негайно відійдіть від пісочниці, поки не трапилось лихо. І запамʼятайте головне правило Патрона, яке врятувало багато життів.",
        "— А що це за правило? — обережно відходячи від знахідки, спитали друзі.",
        " ",
        "Чіпати не можна нічого руками,\nНе можна штовхати предмети ногами!\nЯкщо дивна річ на дорозі лежить,\nДорослим скажи, виклич службу за мить!",
        " ",
        "Обережно відійшовши на десятки кроків від знахідки, хлопці одразу ж розповіли батькам про те, що знайшли на дитячому майданчику. Дорослі негайно зателефонували за номером 101, і незчулися, як за лічені хвилини машина рятувальників прибула на місце!",
        "— Он ти де, друже! — вийшовши з кабіни автомобіля, гукнув рятувальник. — А ми тебе скрізь шукаємо!",
        "— Патрон відчуває небезпеку й поспішає на порятунок! — прогавкав пес. — Якби не ці спритні лапи й гострий нюх, хтозна, що могло трапитись з хлопчаками.",
        "— Молодець, Патроне! Великі герої не обов'язково великі! — узявши песика на руки, мовив рятувальник. — А ви, хлопці, будьте обережні й повсякчас згадуйте правило Патрона, коли натрапите на незнайому річ!",
        "1",
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
