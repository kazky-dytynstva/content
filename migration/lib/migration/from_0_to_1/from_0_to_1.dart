import 'dart:io';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_0_to_1/dto/_old/tale/tale_dto.dart'
    as old;
import 'package:migration/migration/base_migration.dart';
import 'package:mp3_info/mp3_info.dart';

class From0to1 extends BaseDataMigration {
  @override
  int get appBuildNumberOld => 147;

  @override
  String get appVersionOld => '4.8.1';

  @override
  int get dataVersionOld => 0;

  String get taleDataPathOld => '$dataPathOld/tales';

  String get taleDataPathNew => '$dataPathNew/tales';

  String get peopleDataPathOld => '$dataPathOld/people';

  String get peopleDataPathNew => '$dataPathNew/people';

  String get _originalSeparator => '.original.';

  @override
  Future<bool> migrate() async =>
      await _migrateTales() && await _migratePeople();

  Future<bool> _migratePeople() async {
    log('>>> people started');
    // lets copy json data
    final oldFile = File('$peopleDataPathOld/list.json');
    final newJsonFile =
        await File('$peopleDataPathNew/list.json').create(recursive: true);
    await newJsonFile.writeAsBytes(await oldFile.readAsBytes());

    // lets copy images
    await _migratePeopleImages(
      pathOld: peopleDataPathOld,
      pathNew: peopleDataPathNew,
    );

    // lets copy image originals
    await _migratePeopleImageOriginals(
      pathOld: peopleDataPathOld,
      pathNew: peopleDataPathNew,
    );

    log('<<< people dane');
    return true;
  }

  Future<bool> _migrateTales() async {
    log('>>> tales started');
    await _migrateTaleJson();
    await _migrateTaleImagesAndAudio();

    log('<<< tales done');
    return true;
  }

  Future<void> _migrateTaleJson() async {
    final talesJsonPath = '$taleDataPathOld/v2/list.json';
    final json = await readJsonList(talesJsonPath);

    final oldTales =
        json.map((e) => old.TaleDto.fromJson(e)).toList(growable: false);

    final newTales = <TaleDto>[];

    final helper = _MigrateTalesHelper(taleDataPathOld);
    for (final old in oldTales) {
      final newTale = await helper.mapTale(old);
      newTales.add(newTale);
    }

    newTales.sort((a, b) => a.id.compareTo(b.id));

    //region asserts
    final oldIdList = oldTales.map((e) => e.id).toList();
    assert(oldTales.length == oldIdList.length);
    final newIdList = newTales.map((e) => e.id).toList();
    assert(newTales.length == newIdList.length);
    assert(newTales.length == oldIdList.length);
    var id = -1;
    for (final tale in newTales) {
      assert(tale.id == id + 1);
      id = tale.id;
    }
    //endregion asserts

    await saveJsonListToFile(
      data: newTales.map((e) => e.toJson()).toList(),
      filePath: '$taleDataPathNew/list.json',
    );
  }

  Future<void> _migrateTaleImagesAndAudio() async {
    File getNewFile({
      required int id,
      required String format,
      int? index,
      String? extraFolder,
      String fileName = '0',
      bool isOriginal = false,
    }) {
      // 0 here is a first chapter with index 0
      final pathBuilder = StringBuffer('$taleDataPathNew/$id/0/')
        ..write(extraFolder ?? '')
        ..write(fileName)
        ..write(index == null ? '' : '_$index')
        ..write(isOriginal ? _originalSeparator : '.')
        ..write(format);
      return File(pathBuilder.toString());
    }

    Future<Iterable<FileSystemEntity>> getElements(String folder) async =>
        (await Directory('$taleDataPathOld/$folder').list().toList())
            .where((element) => !element.path.contains('.DS_Store'));

    // region copy images
    final images = await getElements('img');
    for (var element in images) {
      final oldName = element.path.split('/').last;
      final format = oldName.split('.').last;
      final id = int.parse(oldName.split('.').first.replaceAll('id_', ''));
      final newFile = getNewFile(id: id, format: format, extraFolder: 'img/');
      final oldFile = File(element.path);

      await (await (newFile.create(recursive: true)))
          .writeAsBytes(await oldFile.readAsBytes());
    }
    // endregion copy images

    // region copy original images
    final imageOriginals = await getElements('img_originals');
    for (var element in imageOriginals) {
      final oldName = element.path.split('/').last;
      final format = oldName.split('.').last;
      final nameParts = oldName.split('.').first.split('_');
      nameParts.removeAt(0);
      final id = int.parse(nameParts.first);
      final newFile = getNewFile(
        id: id,
        format: format,
        extraFolder: 'img/',
        index: nameParts.length == 1 ? null : int.parse(nameParts.last),
        isOriginal: true,
      );
      final oldFile = File(element.path);

      await (await (newFile.create(recursive: true)))
          .writeAsBytes(await oldFile.readAsBytes());
    }
    // endregion copy image originals

    // region copy audio
    final audios = await getElements('audio');
    for (var element in audios) {
      final oldName = element.path.split('/').last;
      final format = oldName.split('.').last;
      final id = int.parse(oldName.split('.').first.replaceAll('id_', ''));
      final newFile = getNewFile(id: id, format: format, fileName: 'audio');
      final oldFile = File(element.path);

      await (await (newFile.create(recursive: true)))
          .writeAsBytes(await oldFile.readAsBytes());
    }
    // endregion copy audio

    // region copy audio originals
    final audioOriginals = await getElements('audio_originals');
    for (var element in audioOriginals) {
      final oldName = element.path.split('/').last;
      final format = oldName.split('.').last;
      final id = int.parse(oldName.split('.').first.replaceAll('id_', ''));
      final newFile = getNewFile(
        id: id,
        format: format,
        fileName: 'audio',
        isOriginal: true,
      );
      final oldFile = File(element.path);

      await (await (newFile.create(recursive: true)))
          .writeAsBytes(await oldFile.readAsBytes());
    }
    // endregion copy audio originals

    return;
  }

  Future<void> _migratePeopleImages({
    required String pathOld,
    required String pathNew,
  }) async {
    final images = await Directory('$pathOld/img').list().toList();
    for (var element in images) {
      final name = _getNameFromPath(element.path);
      await (await File('$pathNew/img/$name').create(recursive: true))
          .writeAsBytes(await File(element.path).readAsBytes());
    }
  }

  Future<void> _migratePeopleImageOriginals({
    required String pathOld,
    required String pathNew,
  }) async {
    final originalImages =
        await Directory('$pathOld/img_originals').list().toList();
    for (var element in originalImages) {
      final oldName = _getNameFromPath(element.path);
      final newName = oldName.split('.').join(_originalSeparator);
      await (await File('$pathNew/img/$newName').create(recursive: true))
          .writeAsBytes(await File(element.path).readAsBytes());
    }
  }

  String _getNameFromPath(String path) {
    final oldName = path.split('/').last;
    final parts = oldName.split('.');
    final name = parts.first.replaceAll('id_', '').trim();
    return '$name.${parts.last}';
  }
}

class _MigrateTalesHelper {
  final String oldTalePath;

  _MigrateTalesHelper(this.oldTalePath);

  Future<TaleDto> mapTale(old.TaleDto old) async => TaleDto(
        id: old.id,
        name: old.name,
        createDate: old.createDate,
        tags: _mapTaleTags(old),
        content: await _mapContent(old),
        crew: _mapCrew(old),
      );

  Set<String> _mapTaleTags(old.TaleDto old) {
    final tags = <String>{};

    if (old.hasAudio == true) {
      tags.add('audio');
    }
    if (old.crewIds?.authors?.isNotEmpty == true) {
      tags.add('author');
    }
    if (old.lullaby == true) {
      tags.add('lullaby');
    }
    if (old.text != null) {
      tags.add('text');
    }

    assert(tags.isNotEmpty, 'Tags can not be empty. Tale id=${old.id}');

    return tags;
  }

  TaleCrewDto? _mapCrew(old.TaleDto old) {
    final crew = old.crewIds;
    if (crew == null) return null;

    assert(
      crew.authors == null ||
          crew.authors!.toSet().length == crew.authors!.length,
      'Tale authors should be unique. Tale id = ${old.id}',
    );

    assert(
      crew.readers == null ||
          crew.readers!.toSet().length == crew.readers!.length,
      'Tale readers should be unique. Tale id = ${old.id}',
    );

    assert(
      crew.musicians == null ||
          crew.musicians!.toSet().length == crew.musicians!.length,
      'Tale musicians should be unique. Tale id = ${old.id}',
    );

    assert(
      crew.translators == null ||
          crew.translators!.toSet().length == crew.translators!.length,
      'Tale translators should be unique. Tale id = ${old.id}',
    );

    assert(
      crew.graphics == null ||
          crew.graphics!.toSet().length == crew.graphics!.length,
      'Tale graphics should be unique. Tale id = ${old.id}',
    );

    return TaleCrewDto(
      authors: crew.authors,
      readers: crew.readers,
      musicians: crew.musicians,
      translators: crew.translators,
      graphics: crew.graphics,
    );
  }

  String _getOldTaleAudioPathById(int id) => '$oldTalePath/audio/id_$id.mp3';

  Future<List<TaleChapterDto>> _mapContent(old.TaleDto old) async {
    final text = <String>[];

    if (old.text != null) {
      text.addAll(old.text!.split('||'));
      assert(text.isNotEmpty);
    }

    late final ChapterAudioDto? audioDto;
    if (old.hasAudio == true) {
      final path = _getOldTaleAudioPathById(old.id);
      final file = File(path);

      final info = MP3Processor.fromFile(file);
      audioDto = ChapterAudioDto(
        duration: info.duration.inMilliseconds,
        size: file.lengthSync(),
      );
      assert(audioDto.duration > 0);
      assert(audioDto.size > 0);
    } else {
      audioDto = null;
    }

    return [
      TaleChapterDto(
        title: null,
        audio: audioDto,
        text: text.isEmpty ? null : text,
        imageCount: 1,
      )
    ];
  }
}
