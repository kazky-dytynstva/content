import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/add_item_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/audio_util.dart';

class AddTaleHelper extends AddItemHelper {
  AddTaleHelper(From2to2 migration)
      : super(
          migration,
          addItemName: 'Tale',
          folderName: 'tales',
        );

  late TaleDto tale;

  String getTalePath(int chapterIndex) => '$dataPath/$nextId/$chapterIndex/';

  @override
  Future<bool> validate({bool post = false}) async {
    try {
      final all = await _getAll();

      final idList = all.map((e) => e.id).toSet();

      assert(
        idList.length == all.length,
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
      // Tags.poem,
    };

    tale = TaleDto(
      id: nextId,
      name: 'Дракончик Оллі',
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
        authors: [11],
        readers: null,
        musicians: null,
        translators: null,
        graphics: [78],
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
        "У курнику здійнявся справжнісінький переполох. Мама-квочка теж була шокована. Адже з її яйця вилупилось не зрозуміло що! Це було не курчатко, не гусятко, і навіть не індичатко! Маленьке лисе створіння дивилося на неї великими очима, сповненими любові та довіри. А велетенські проти тулубу крильця були ще такими незграбними...",
        "Оллі (як його згодом назвали в курнику) виліз зі шкаралупки й тремтячим голосом сказав: «Ма-ма!» У цю ж хвилину квочка ледь не знепритомніла!",
        "Оллі був страшенним незграбою! Все, чого він торкався, руйнувалось. А ще він їв за трьох. Справжній ненажера!",
        "У курнику його називали переростком, дивакуватим недокурчам, справжньою потворою! Але мама-квочка завжди знала, що Оллі не такий, ВІН ОСОБЛИВИЙ! І щодня шепотіла синочкові на вушко, як сильно його любить!",
        "Від цієї любові Оллі зростав дуже сильним! Ніхто не міг побороти його сам на сам. Але підлітки з курника постійно цькували Оллі просто через те, що він не був схожим на інших.",
        "Одного разу індичата вирішили покепкувати з Оллі, завівши його в багнюку, що знаходилась неподалік ферми. Влітку там часто борсались свині. Тож пташенята вирішили, що буде дуже смішно, коли Оллі опиниться серед багна. Крім того, хтось сказав, що Оллі боїться вологи, бо геть не вміє плавати.",
        "«О, як же це буде весело, коли він незграбно борсатиметься і його величезні крила тріпотітимуть від сорому й страху!» — шепотіли злі язички.",
        "Тож вранці, коли всі вийшли на галявинку скубати травичку та шукати черв'ячків, хтось з індичат сказав: «Ходімо трохи далі, тут уже все визбирали! А он там, за очеретом, дуже смачна трава! А черв'яки так узагалі розміром з пацючий хвіст!»",
        "Оченята Оллі загорілись вогниками! Він дуже любив поїсти, тож без роздумів посунув уперед за іншими.",
        "Біля очерету й справді була висока зелена трава, а під нею купа смачненьких черв’яків, тож Оллі радо ласував усім цим, не помічаючи, що інші весь час тримаються позаду.",
        "— Коко, Мо! — казав Оллі індичатам. — Ця місцина — справжня знахідка! І чому ми раніше сюди не приходили!?",
        "— Бо мами забороняють сунути за очерет, — раптом сказав менший братик Мо, не підозрюючи, що підлітки мають злі наміри.",
        "— Але чому?",
        "Та не встиг Оллі відвести погляд, як побачив за кущами верболозу велетенського лиса, що чатував на пташенят!",
        "— А-а-а!!! — закричали індичата і почали розбігатись навсібіч.",
        "Та, здавалось, від лиса не втекти!",
        "Враз Оллі помітив, як мале індиченя, перечепившись через повзуче коріння очерету, впало прямісінько в болото. А лис стрімко наближався, облизуючи носа.",
        "— О, ні! Там залишився мій брат! — скрикнув Мо. Але у нього не стало духу повернутись за малюком Еґі.",
        "І хоча Оллі мав шанс утекти, залишивши лису на обід мале індиченя, та він не зробив цього.",
        "Враз він встав перед Еґі й, розправивши крила, загарчав так, як не вміє жоден птах! З його пащі повіяло вогненним подихом! Та й таким, що лису, який от-от хотів їх обох зжерти, підсмажило довгі вуса.",
        "— Дракон! — заскавчав лис, тікаючи в хащі.",
        "— Дракон?! — переглянулись захекані індичата, побачивши клуб диму, що здійнявся у повітря.",
        "І хоча звістка про дракончика Оллі за лічені хвилини дісталась курнику й навела там переполоху, та мама-квочка чекала на синочка з невимовною гордістю! І відтоді жоден лис не посмів сунути свого носа навіть поблизу ферми!",
      ];
}

class Tags {
  Tags._();

  static const String text = 'text';
  static const String author = 'author';
  static const String audio = 'audio';
  static const String poem = 'poem';
  static const String lullaby = 'lullaby';
}
