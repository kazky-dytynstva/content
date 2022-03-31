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
      name: 'Святковий сервіз',
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
        graphics: [64],
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
        "Одного чарівного вечора напередодні Великодня маленький хлопчик Дарусик та його кудлатий друг – песик Міккі сиділи біля віконечка і спостерігали за тим, як легенький весняний вітерець гойдає віти дерев. Малята гортали книжечку із чарівними казками і з нетерпінням чекали світлого свята!",
        "Раптом хлопчик почув дивні звуки, які доносились з буфету, де матуся зберігала святковий посуд.",
        "– Міккі, ти чуєш – там хтось є! – сказав Дарусик.",
        "– Хто там може бути? – здивувався собака. – Там лише старий посуд!",
        "Хлопчик підійшов ближче і тихенько відчинив дверцята. Аж раптом почув, як хтось говорить:",
        "– Досить уже красуватись у дзеркалі! Всеодно нас не запросять на свято, так само, як і торік.",
        "– А я впевнена, що запросять! Ми найвишуканіша сім‘я святкового сервізу! Коли ж нас запрошувати, як не на Великдень!?",
        "Мама-Цукорниця з татом-Чайником шаруділи у буфеті про щось сперечаючись. Цукорниця до блиску натирала щічки своїх донечок-чашечок, що чемно сиділи у порцелянових блюдечках.",
        "Дарусику стало так цікаво, що він не помітив, як рипнув дверцятами і тим самим сполохав родину святкового посуду.",
        "Тато-Чайник вмить завмер, підвівши свого носа, а мама-Цукорниця і незчулася, як загубила мереживну серветку десь серед блюдечок.",
        "– То ви справжні! – вигукнув хлопчик. – Міккі, біжи мерщій сюди! Вони справжні!",
        "Собака підійшов до буфету і глянув на святковий сервіз, що непорушно стояв тут роками.",
        "– Вони мовчать і не рухаються. Дарусику, хотімо спати! Тобі, напевно, примарилось.",
        "– Зовсім ні! – вигукнув хлопчик. – Вони говорили! Я сам чув! А Цукорниця навіть натирала серветкою оті чашечки! Я сам бачив!",
        "Дарусик ще раз придивлявся до сервізу, але посуд мовчав.",
        "– Прошу вас, скажіть щось! – благав хлопчик. – Це ж справжня магія!",
        "Та як би хлопчина не прохав – нічого не відбувалося.",
        "– Дай-но мені понюхати серветку. – мовив Міккі. – Якщо хтось там хтось справді був – я одразу відчую!",
        "Сервіз стояв так високо, що малюк ледь дотягнувся до серветки і не помітив, як випадково зачепив маленьку чашечку.",
        "– О, ні! – раптом пролунало з буфету, коли чашка покотилась униз і ледь не розбилась об землю!",
        "На щастя, кудлатий підхопив чашку своїми лапами і тим самим врятував їй життя.",
        "Мама-Цукорниця відчула, як з-під її кришечки проступив піт. Вона так злякалась за свою донечку Філіжаночку, що випадково видала секрет святкового сервізу.",
        "– То ви справжні! Я ж казав! – радів Дарусик. – Чому ж ви мовчали?",
        "– Бо нам заборонено розмовляти з людьми! – відповів тато-Чайник. – Якщо хтось дізнається про нашу таємницю, то ми стаємо вкрай беззахисні! Нас можуть розбити, або розлучити, що ще гірше! А ми родина – ми святковий сервіз, який береться на великі свята!",
        "– Але ж мама вас зовсім не дістає звідси! – мовив Дарусик.",
        "– Так, – сумно зітхнула мама-Цукорниця. – Ми вже давно не в моді! Зараз багато дешевого пластикового посуду, який заполонив світ. Кому тепер діло до старої порцеляни!?",
        "– Сумно…– прошепотів Дарусик. – А для чого вас тоді тримають у буфеті?",
        "– Для краси! – відказала мама-Цукорниця, милуючись у дзеркалі. – А ще ми сервіз з історією! Ми частували гостей на весіллі твоїх батьків, а потім у день твого народження! Нас запрошували до столу на великі свята, такі як Пасха, Різдво та Новий рік! Але останнім часом про нас геть забули… Тепер дива трапляються вкрай рідко.",
        "– Не забули! – впевнено відповів Дарусик. – завтра найсвітліше християнське свято - Великдень, а це значить, що диву бути!",
        "– Готуймось до столу! – підтримав хлопчика вірний друг – собака. – Попереду вся ніч!",
        "Дарусик та Міккі узяли чисті ганчірочки і до блиску натерли святковий сервіз! Вони так натомились, що й не помітили, як пробило за дванадцяту і їм вже треба було збиратись до ліжечка.",
        "Наступного дня, коли всі повернулись з церкви, матуся почала накривати на стіл.",
        "Раптом вона зрозуміла, що з одного набору не вистачає блюдечка, з іншого – чашечки... Взагалі у хаті коїлось щось дивне!",
        "– Любий, ти не бачив, де білі чашки, з яких ми зазвичай п’ємо на кухні чай? – звернулась до тата матуся.",
        "– Не бачив, люба, – відповів чоловік.",
        "– То що тепер робити? – дивувалась мама.",
        "– А давай дістанемо наш святковий сервіз! – раптом запропонував Дарусик.",
        "– Але ж він не готовий! Я підготувала вчора інший посуд.",
        "– Готовий, матусю! Він готувався до цього дня багато років!",
        "Почувши це, мама усміхнулась до хлопчика і попрямувала до буфету.",
        "Вона була дуже здивована, що сервіз, який не діставався роками, був надзвичайно чистим і мерехтів на світлі.",
        "На святковий обід за столом зібралась уся родина! Гості дарували одне одному Великодні писанки та пили запашний липовий чай з духмяним медом. І керував усім цим застіллям святковий сервіз, який нагадував усім про ті безцінні миті, коли вся родина збиралась за святковим столом!",
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
