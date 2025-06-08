import 'dart:convert';
import 'dart:io';
import 'package:dto/dto.dart';
import 'package:supabase/supabase.dart';

void main() async {
  final supabase = SupabaseClient(
    'https://wzsrzjlhogdmojqelvf.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cC6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6c3J6amxob2dkbW9qcWVsdmZrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzM4OTQ1MCwiZXhwIjoyMDYyOTY1NDUwfQ.gUzGgt5R9Yg-QX2HjUy_3aOhOBveG99U7ReDzzvB-uQ',
  );

  await _exportPeople(supabase);
  // await _exportTales(supabase);
  print('🎉 done');
}

Future<void> _exportPeople(SupabaseClient supabase) async {
  // final peopleJsonFile = File(
  //   '/Users/andrii.antonov/dev/kazky/content/data/3/people/list.json',
  // );

  // final peopleContent = await peopleJsonFile.readAsString();
  // final peopleJson =
  //     (json.decode(peopleContent) as List)
  //         .map((e) => PersonDto.fromJson(e))
  //         .toList();

  // final table = supabase.from('people');

  // for (final person in peopleJson) {
  //   try {
  //     await table.update(person.toSupaJson()).eq('id', person.id);
  //   } catch (e) {
  //     print('Failed to update person ${person.id}');
  //     print(e);
  //     rethrow;
  //   }
  // }

  final dir = Directory(
    '/Users/andrii.antonov/dev/kazky/content/data/4/people',
  );

  final bucket = supabase.storage.from('people');

  final dirs = dir.listSync().whereType<Directory>();

  for (final dir in dirs) {
    final personId = dir.path.split('/').last;
    final files = dir.listSync().whereType<File>().toList();
    for (final file in files) {
      final fileName = file.path.split('/').last;
      final String fullPath = await bucket.upload(
        '$personId/$fileName',
        file,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
      print('Uploaded file: $fullPath');
    }
  }
}

Future<void> _exportTales(SupabaseClient supabase) async {
  final talesJsonFile = File(
    '/Users/andrii.antonov/dev/kazky/content/data/3/tales/list.json',
  );

  final talesContent = await talesJsonFile.readAsString();
  final talesJson =
      (json.decode(talesContent) as List)
          .map((e) => TaleDto.fromJson(e))
          .toList();

  final table = supabase.from('tales');

  for (final tale in talesJson) {
    try {
      await table.update(tale.toSupaJson()).eq('id', tale.id);
    } catch (e) {
      print('Failed to update tale ${tale.id}');
      print(e);
      rethrow;
    }
  }

  // final bucket = supabase.storage.from('tales');
  // final rootDir =
  //     Directory('/Users/andrii.antonov/dev/kazky/content/data/3/tales/');

  // final taleDirs = rootDir.listSync().whereType<Directory>().toList();

  // final skippedBigFiles = <String>[];

  // var dirCount = 0;

  // for (final dir in taleDirs) {
  //   final taleId = dir.path.split('/').last;
  //   print('🏎️ uploading tale $taleId. ($dirCount/${taleDirs.length})');
  //   dirCount++;

  //   final files = dir.listSync().whereType<File>().toList();

  //   for (final file in files) {
  //     final fileName = file.path.split('/').last;

  //     final filePath = '$taleId/$fileName';

  //     if (await bucket.exists(filePath)) {
  //       print('file $filePath already exists');
  //       continue;
  //     }

  //     if (file.lengthSync() >= 50 * 1024 * 1024) {
  //       print('file $filePath is too big');
  //       skippedBigFiles.add(file.path);
  //       continue;
  //     }

  //     final String fullPath = await bucket.upload(
  //       filePath,
  //       file,
  //     );
  //     fullPath.toString();
  //   }

  //   final imgDir = Directory('${dir.path}/img');

  //   final imgFiles = imgDir.listSync().whereType<File>().toList();
  //   for (final fileEntity in imgFiles) {
  //     final fileName = fileEntity.path.split('/').last;

  //     final filePath = '$taleId/$fileName';

  //     if (await bucket.exists(filePath)) {
  //       print('file $filePath already exists');
  //       continue;
  //     }

  //     final String fullPath = await bucket.upload(
  //       filePath,
  //       fileEntity,
  //     );
  //     fullPath.toString();
  //   }

  //   print('🏁 uploaded tale $taleId files');
  // }

  // if (skippedBigFiles.isEmpty) {
  //   print('✅ all files uploaded');
  //   return;
  // }

  // print('❌❌❌ skipped big files:');
  // for (final file in skippedBigFiles) {
  //   print(file);
  // }
}

extension on TaleDto {
  Map<String, dynamic> toSupaJsonLocal() {
    return {
      'id': id,
      'name': name,
      'create_date': createDate.toIso8601String(),
      if (updateDate != null) 'update_date': updateDate!.toIso8601String(),
      'summary': summary,
      'tags': tags.map((e) => e.name).toList(),
      if (text != null) 'paragraphs': text!.paragraphs,
      if (text != null) 'min_reading_time': text!.minReadingTime,
      if (text != null) 'max_reading_time': text!.maxReadingTime,
      if (crew?.authors != null) 'authors': crew!.authors,
      if (crew?.graphics != null) 'graphics': crew!.graphics,
      if (crew?.readers != null) 'readers': crew!.readers,
      if (crew?.musicians != null) 'musicians': crew!.musicians,
      if (crew?.translators != null) 'translators': crew!.translators,
      if (audio != null) 'audio_file_size': audio!.fileSize,
      if (audio != null) 'audio_duration': audio!.duration,
    };
  }
}

extension on PersonDto {
  Map<String, dynamic> toLocalSupaJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      if (info != null) 'info': info,
      if (url != null) 'url': url,
      'gender': gender.name,
      if (roles?.contains(PersonRoleDto.crew) == true) 'is_crew': true,
    };
  }
}

bool deepCompare(dynamic a, dynamic b) {
  if (a is Map && b is Map) {
    if (a.length != b.length) return false;
    for (var key in a.keys) {
      if (!b.containsKey(key)) return false;
      if (!deepCompare(a[key], b[key])) return false;
    }
    return true;
  } else if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (!deepCompare(a[i], b[i])) return false;
    }
    return true;
  } else {
    return a == b;
  }
}
