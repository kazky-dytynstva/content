import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends _AddTaleHelper {
  AddTaleHelper(From2to2 migration) : super(migration);

  @override
  String get taleName => 'Різдвяне диво';

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
        "В одному невеличкому лісі жила руда й прудка білочка на ім’я Додо. Настала холодна зима, яка вкрила ліс білосніжною ковдрою. Білочка змінила своє яскраве вбрання на сіреньку шубку. Усі звірі з нетерпінням чекали на Різдво, адже кожний з них вірив у різдвяне чудо. Родина Додо жила бідно. А взимку їм було особливо складно, бо їжі не вистачало на всіх. Дідусь руденької розповідав, що у різдвяну ніч можна знайти золотий горішок. Якщо його посадити у горщик, він даватиме плоди: багато горіхів.",
        "- Якщо я знайду золотий горішок, уся моя родина буде нагодованою, – подумала про себе білочка.",
        "Прудка Додо вискочила з нірки на двір.",
        "– Так, так, так, – мовила руденька, – дідусь казав, що золотий горішок знайти нелегко, адже він захований у груді снігу.",
        "Білочка оббігла весь ліс, але горішка ніде так і не знайшла. Із повним розпачем вона повернулася додому.",
        "– Рудусю, (так називав Білочку дідусь) ти де була і чому така засмучена?",
        "– Дідусю, я оббігала весь ліс у пошуках золотого горішка, але ніде його так і не знайшла. Це все вигадки. Їх насправді не існує, – мовила зі сльозами на очах Білочка.",
        "– Не засмучуйся, маленька, – сказав дідусь й, посадивши онучку на колінця, додав: у Різдво трапляються дива, тому лише у ніч з 6 на 7 січня можна знайти горішок. Кажуть, він лежить біля старої ялинки, що у кінці лісу. Але його може знайти лише той, хто дійсно на нього заслуговує. На горішок у цю ніч полює багато білок-хитрунів, які бажають легкої наживи. Завтра ввечері виходь з нірки і чимчикуй до старої ялинки, шукай уважно, у подумах згадуй свою родину, якій так потрібен цей горішок.",
        "Додо наступного дня вийшла з нірки, взяла шматочок сірого хліба і пішла у ліс, куди вказував дідусь. Дорога була довгою і небезпечною. Білочка так швидко бігла, що перечепилася і впала. З її торбинки випав шматочок хліба. Руденька почала плакати, адже вона дуже зголодніла, а навколо сутеніло.",
        "– Як я зможу продовжити пошуки горішка? Я підвела всю свою родину, яка чекає на мене і вірить у мене? У цей час Білочка почала розкопувати грудки снігу, щоб відшукати хліб.",
        "Сльози крапали на сніг. Від гарячих крапель сніг почав танути і Додо побачила золоте сяйво, від якого руденька примружила очі.",
        "– Що це? – здивовано вигукнула білочка.",
        "Руденька підійшла ближче і побачила диво – золотий горішок!",
        "– Невже це все правда? Невже я тебе знайшла? – мовила білочка.",
        "Додо взяла у лапки горішок і поклала у свою торбинку.",
        "Прийшовши додому, Білочка довго розповідала своїм рідним про різдвяну пригоду. Матуся посадила горішок і з нього вийшло багато плодів, якими насолоджувалися і братики, і сестрички білочки. Із того часу Додо стала вірити у різдвяне диво. Це свято стало для неї особливим.",
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
