import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Хоробрий Мурчик';

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
        "Жило собі кошеня на ім’я Мурчик. Воно мало смугасту шерсточку і довгий хвостик. Дідусь розповідав Мурчику, що їхнім давнім родичем був тигр. Котик мріяв познайомитися із цим родичем і стати сильним та хоробрим, які він. У дворі Мурчика часто ганяли собаки. Саме тоді йому найбільше хотілося зустріти свого родича тигра та якнайшвидше навчитися в нього хоробрості.",
        "Одного разу родина, у якій жив котик, зібралася до зоопарку.",
        "– Овва, дідусь розповідав, що тигри живуть у зоопарку. Це чудова нагода зустріти тигра!",
        "Крадькома Мурчик підійшов до машини і прудко заскочив усередину.",
        "– Усі пристебніть паски безпеки, – суворо мовив тато. – Рушаймо!",
        "У Мурчика від хвилювання серце аж вистрибувало з грудей.",
        "– Скоро я побачу свого родича, який навчить мене бути сильним хоробрим, як і він, – прошепотіло кошеня.",
        "– Ми на місці, – сказав тато.",
        "Уся родина вийшла з машини, Мурчик теж нишком вистрибнув і побіг так, щоб ніхто його не помітив.",
        "Коли він зайшов до зоопарку, то побачив величезну кількість тварин. Першим Мурчик зустрів Жирафу.",
        "– Маленький, ти когось шукаєш, чи ти заблукав? – запитала Жирафа.",
        "– Ні, пані Жирафо, – мовив котик, – я шукаю свого далекого родича тигра. Я хочу навчитися в нього бути сильним і хоробрим.",
        "– О! – вигукнула Жирафа. – А чому ти не хочеш бути схожим на мене? Я також сильна і хоробра, я маю дооовгу шию, тому жоден ворог до мене не дістане.",
        "– Ні, дякую, вельмишановна пані. Я краще пошукаю свого родича.",
        "– Добре! Йди до самого кінця алеї, вольєри тигрів там.",
        "Мурчик подякував і попрямував, куди вказала пані Жирафа.",
        "Праворуч від Жирафи, у клітці сидів Ведмідь.",
        "– Ти що тут робиш, малий? – проревів той.",
        "– Я шукаю свого далекий родича тигра. Я хочу бути схожим на нього, щоб собаки мене більше не чіпали.",
        "– Та невже? Можливо, ти хочеш бути схожим на мене? Я сміливий і дужий. А ще я можу спати всю зиму і прокинутися аж весною.",
        "– Ні, пане Ведмедю, спати я не дуже люблю. Краще пошукаю тигра.",
        "– Тоді прямуй далі, тигри там.",
        "Кошеня дійшло до кінця алеї і побачило великих смугастих тигрів. Вони зачаровували своєю граціозністю.",
        "– Добрий день, – несміливо мовило кошеня, – я Мурчик, ваш далекий родич.",
        "Тигр нахилив голову вниз, глянув на малого і мовив:",
        "– Ти? Мій родич? Цікаво!",
        "– Так, мені дідусь розповів. Гляньте, я теж смугастий і хвостатий.",
        "– Ну якщо дідусь сказав, значить так воно і є.",
        "– Навчіть мене бути таким хоробрим і сміливим, як і ви, бо у дворі мене ганяють собаки.",
        "– Собаки ганяють, кажеш? Це погано! Зараз я навчу тебе гарчати. Зціпи зуби і скажи: рррррррррррррррррр.",
        "Могутній Тигр заревів на весь зоопарк.",
        "– Ррр,– повторив Мурчик ледь чутно.",
        "– А ти здібний учень, Мурчику. У тебе добре виходить. Спробуй ще раз, сердитіше.",
        "– Ррррррррррррррррррррр, – чимдуж проричав Мурчик.",
        "– Ось так тебе злякається будь-хто! Ти справді мій далекий родич. Тепер я не маю сумнівів. Рушай додому і більше нікого і нічого не бійся. А дідусеві передавай вітання.",
        "– Дякую! – зраділо кошеня і побігло назад до машини.",
        "Родина саме збиралася вирушати. Мурчик встиг заскочити в останній момент. А поки вони їхали, котик уявляв, як він першим ділом злякає собак.",
        "Повернувшись додому, Мурчик одразу побіг у двір. Собаки, побачивши малого, побігли до нього та, як завжди, почали суворо гавкати.",
        "– Ррррррррррррррррррр! – загарчав Мурчик. Його мордочка була дуже серйозною, а шерсточка стала дибки, як колючки кактуса. Собаки з переляку побігли геть.",
        "– Ого! – здивувався котик, – працює! Тепер я справжній тигрррр!",
        "Надвір вийшов дідусь.",
        "– Дідусю, я познайомився з нашим далеким родичем тигром. Він навчив мене хоробрості й мужності. Тепер я нікого і нічого не боюсь.",
        "– Я вірив у тебе, моє хоробре тигреня, – сміючись пронявчав дідусь-кіт і лагідно лизнув онука у щічку.",
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
