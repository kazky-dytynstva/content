import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Лісові пригоди';

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
        "Надворі світило лагідне травневе сонечко. Пташки весело співали, сповіщаючи дзвінким цвіріньканням, що скоро прийде літо.",
        "У невеличкому лісі жила родина ведмедиків: матуся і двоє ведмежаток – Лапусик та Михасик. Щодня ненька надовго залишала малят самих і ходила по харчі для своєї родини.",
        " ",
        "– Матусю, де ти так довго була? – часто запитував Михасик.",
        "– Їжі у нашому лісі залишилось небагато, тому я ходила по смаколики аж у віддалене село.",
        " ",
        "Усі мешканці лісу чули перекази, що у селищі Околиця є величезні гриби. Одного такого грибочка було б достатньо, щоб годувати всю ведмежу родину цілий місяць.",
        "Коли малята збиралися до сну, Михасик прошепотів братику:",
        "– Незабаром День матері. Я хочу піти до Околиці, щоб принести звідти грибочка. От наша мама зрадіє такому подарунку!.",
        "– Але ж це небезпечно, – занепокоївся Лапусик, – у лісі є хижі звірі, які охороняють свою територію!",
        "– Я буду дуже обачним! – пообіцяв Михасик, і заснув згорнувшись клубочком біля братика.",
        "Наступного ранку, взявши кошик, сміливий Михасик вирушив до Околиці. Дорога була довгою й небезпечною. Малий навіть думав, що заблукав. Але на зустріч саме йшла білочка. Вона і вказала шлях до галявини з диво-грибами.",
        "Гриби там були справді велетенськими. Малюк зміг зірвати лише один, але і цього мало вистачити.",
        "Співаючи радісну пісеньку, Михасик попрямував додому. Але враз натрапив на Вовка, який йшов із кошиком грибів. Ведмедик злякався страшного звіра і вмить затих.",
        "– Куди прямуєш, малюче? – рикнув Вовк.",
        "– Д-додому, – тремтячим голосом відповів Михасик.",
        "– А що це в тебе в кошику?",
        "– Г-гриби.",
        "– Ти навіщо зірвав наші гриби?",
        "– С-скоро Матусин день! Наша м-мама щодня шукає їжу, щоб нас нагодувати. Тому я вирішив з-зробити їй подарунок на свято. Кажуть, щ-що найкращий подарунок – той, що зробив власноруч.",
        "– Яке ти сміливе та добре ведмежа! Прийти у наш ліс наважується не кожний. Тут дуже небезпечно.",
        " ",
        "Вовчик вирішив трохи провести Михасика. Дорогою він розповів, що лісом ходять легенди про страшних вовків, які, начебто, їдять гостей, що йдуть по гриби в Околицю. Ведмежатко так заслухалося, що геть не дивилося під ноги. Аж раптом щось боляче вчепилося малюкові у лапку.",
        "– Ой лиииишенко! – розплакався Михасик. Він втрапив у капкан, який розставили мисливці.",
        "– Чекай, малий, я тобі допоможу! Тримайся! – заметушився Вовк.",
        "Він намагався відкрити пастку лапами, але нічогісінько не виходило. Тоді Вовк знайшов гілку, просунув у капкан і з усієї сили натиснув на неї. І сталося диво – ведмежатко вдалося звільнити!",
        "– Овваа!!! Ти мій супергерой! – вигукнув Михасик.",
        "– Із капканом ми впорались, але ти пошкодив лапку. Її терміново треба полікувати. Потрібні цілющі трави!",
        "Вовк назбирав листочків подорожнику, барвінку та чистотілу та приклав їх до пораненої лапки Михасика. Ранка стала боліти менше. Але ведмедик продовжував плакати.",
        "– Ще болить? – запитав Вовк.",
        "– Ні, але я загубив грибочка, якого ніс для матусі. – А й справді кошика з подарунком ніде не було.",
        "– Тримай, Михасику! –Вовчик простягнув йому свій кошик з грибами.",
        "– Дякую, Вовчику, ти мій рятівник! Я ніколи не забуду твою доброту.",
        "Звірята підійшли до межі Околиці.",
        "– Прощай, Михасику, дякую за день пригод! Ти дуже добре ведмежа! Бережи себе і завжди дивись під ноги.",
        "– Вовчику, це я тобі дякую! Ти тричі врятував мене.",
        "– Приходь якось до нашого лісу, але вже з родиною, буду радий вас бачити – відказав Вовк.",
        "– Обов’язково.",
        "Ведмежа помахало Вовкові на прощання і побігло додому.",
        " ",
        "Тим часом матуся весь день хвилювалася, куди ж зник її синочок. Навіть хотіла йти за допомогою до лісового дільничного. Аж раптом до будиночку радісно прибіг Михасик. Матінка-ведмедиця чимдуж притиснула його до себе.",
        "– Матусю, це тобі! Із Днем матері, моя рідна, – прошепотів Михасик.",
        "– Синочку, це найкращий подарунок для нашої родини, але більше без мого дозволу ані кроку за межі дому, я дуже хвилювалася.",
        "Із того часу родина ведмедиків ходила до Околиці по гриби разом. Вони потоваришували із сім’єю Вовчиків. А головне – зрозуміли, що не все те правда, що про когось кажуть інші. Часом треба більше дізнатися про когось, щоб зрозуміти, який він є насправді.",
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
