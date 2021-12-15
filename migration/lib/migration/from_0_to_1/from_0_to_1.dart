import 'dart:io';

import 'package:migration/migration/from_0_to_1/dto/_new/tale_dto.dart';
import 'package:migration/migration/from_0_to_1/dto/_old/tale/tale_dto.dart'
    as old;
import 'package:migration/util/base_migration.dart';
import 'package:mp3_info/mp3_info.dart';

class From0to1 extends BaseDataMigration {
  From0to1() : super(oldDataVersion: 0);

  String get taleDataPathOld => '$oldDataPath/tales';

  String get taleDataPathNew => '$newDataPath/tales';

  String get peopleDataPathOld => '$oldDataPath/people';

  String get peopleDataPathNew => '$newDataPath/people';

  @override
  Future<bool> migrate() async =>
      await _migrateTales() && await _migratePeople();

  Future<bool> _migratePeople() async {
    log('>>> people started');
    // lets copy json data
    final oldFile = File('$peopleDataPathOld/list.json');
    final newJsonFile = File('$peopleDataPathNew/list.json')
      ..create(recursive: true);
    await newJsonFile.writeAsBytes(await oldFile.readAsBytes());

    // lets copy images
    final images = Directory('$peopleDataPathOld/img').listSync();
    for (var element in images) {
      final name = element.path.split('/').last;
      final newImg = File('$peopleDataPathNew/img/$name')
        ..create(recursive: true);
      await newImg.writeAsBytes(await File(element.path).readAsBytes());
    }

    // lets copy original images
    final originalImages =
        Directory('$peopleDataPathOld/img_original').listSync();
    for (var element in originalImages) {
      final oldName = element.path.split('/').last;
      final newName = oldName.split('.').join('.origin.');
      final newImg = File('$peopleDataPathNew/img/$newName')
        ..create(recursive: true);
      await newImg.writeAsBytes(await File(element.path).readAsBytes());
    }

    log('<<< people dane');
    return true;
  }

  Future<bool> _migrateTales() async {
    log('>>> tales started');
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

    await saveJsonListToFile(
      data: newTales.map((e) => e.toJson()).toList(),
      filePath: '$taleDataPathNew/list.json',
    );

    log('<<< tales done');
    return true;
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

    if (old.text != null) {
      tags.add('text');
    }

    if (old.hasAudio == true) {
      tags.add('audio');
    }

    if (old.lullaby == true) {
      tags.add('lullaby');
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
        imagesCount: 1,
      )
    ];
  }
}
