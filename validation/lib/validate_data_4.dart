import 'dart:convert';
import 'dart:io';
import 'package:dto/dto.dart';

/// Validates the data/4 folder structure and content integrity
class Data4Validator {
  final String rootPath;
  final List<String> errors = [];

  Data4Validator(this.rootPath);

  /// Run all validation checks
  Future<ValidationResult> validate() async {
    print('🔍 Starting validation of data/4 folder...\n');

    // 1. Check folder existence
    _checkFolderExistence();

    if (errors.isNotEmpty) {
      return ValidationResult(success: false, errors: errors);
    }

    // 2. Check folder structure
    _checkFolderStructure();

    // 3. Validate people data
    await _validatePeopleData();

    // 4. Validate tales data
    await _validateTalesData();

    // 5. Check file structure consistency
    await _validateFileStructure();

    // 6. Validate compressed files
    await _validateCompressedFiles();

    final success = errors.isEmpty;
    print(
      '\n${success ? '✅' : '❌'} Validation ${success ? 'passed' : 'failed'}!',
    );
    print('Errors: ${errors.length}');

    return ValidationResult(success: success, errors: errors);
  }

  /// Check if data/4 folder exists
  void _checkFolderExistence() {
    final data4Dir = Directory('$rootPath/data/4');

    if (!data4Dir.existsSync()) {
      errors.add('❌ data/4 folder does not exist');
      return;
    }

    print('✅ data/4 folder exists');
  }

  /// Check if the basic folder structure is correct
  void _checkFolderStructure() {
    final expectedFolders = ['people', 'tales'];

    for (final folder in expectedFolders) {
      final dir = Directory('$rootPath/data/4/$folder');
      if (!dir.existsSync()) {
        errors.add('❌ Missing required folder: data/4/$folder');
      } else {
        print('✅ data/4/$folder folder exists');
      }
    }

    // Check for list.json files
    for (final folder in expectedFolders) {
      final listFile = File('$rootPath/data/4/$folder/list.json');
      if (!listFile.existsSync()) {
        errors.add('❌ Missing list.json in data/4/$folder');
      } else {
        print('✅ data/4/$folder/list.json exists');
      }
    }
  }

  /// Validate people data and structure
  Future<void> _validatePeopleData() async {
    print('\n📋 Validating people data...');

    final listFile = File('$rootPath/data/4/people/list.json');
    if (!listFile.existsSync()) {
      return; // Already reported in structure check
    }

    try {
      // Read and parse JSON
      final content = await listFile.readAsString();
      final jsonList = jsonDecode(content) as List<dynamic>;

      // Try to parse into PersonDto list
      final people = <PersonDto>[];
      for (var i = 0; i < jsonList.length; i++) {
        try {
          final person = PersonDto.fromJson(
            jsonList[i] as Map<String, dynamic>,
          );
          people.add(person);
        } catch (e) {
          errors.add('❌ Failed to parse person at index $i: $e');
        }
      }

      print('✅ Successfully parsed ${people.length} people');

      // Validate individual person folders
      await _validatePeopleFolders(people);

      // Check for duplicate IDs
      _checkDuplicateIds(people.map((p) => p.id).toList(), 'people');
    } catch (e) {
      errors.add('❌ Failed to parse people/list.json: $e');
    }
  }

  /// Validate individual person folders
  Future<void> _validatePeopleFolders(List<PersonDto> people) async {
    final peopleDir = Directory('$rootPath/data/4/people');
    final entries = peopleDir.listSync();

    // Get all numeric folders
    final folderIds = <int>[];
    for (final entry in entries) {
      if (entry is Directory) {
        final name = entry.path.split('/').last;
        final id = int.tryParse(name);
        if (id != null) {
          folderIds.add(id);
        }
      }
    }

    // Check each person has a corresponding folder
    for (final person in people) {
      final personDir = Directory('$rootPath/data/4/people/${person.id}');

      if (!personDir.existsSync()) {
        errors.add(
          '❌ Person ${person.id} (${person.name} ${person.surname}) has no folder',
        );
        continue;
      }

      // Check folder structure: should have photo.thumbnail.jpg and photo.original.*
      final thumbnailFile = File('${personDir.path}/photo.thumbnail.jpg');
      final files = personDir.listSync();
      final hasOriginal = files.any(
        (f) =>
            f is File && f.path.split('/').last.startsWith('photo.original.'),
      );

      if (!thumbnailFile.existsSync()) {
        errors.add('❌ Person ${person.id} missing photo.thumbnail.jpg');
      }

      if (!hasOriginal) {
        errors.add('❌ Person ${person.id} missing photo.original.* file');
      }
    }

    // Check for orphaned folders (folders without corresponding person in list)
    for (final folderId in folderIds) {
      if (!people.any((p) => p.id == folderId)) {
        errors.add('❌ Orphaned person folder: $folderId (not in list.json)');
      }
    }

    print('✅ Validated ${people.length} person folders');
  }

  /// Validate tales data and structure
  Future<void> _validateTalesData() async {
    print('\n📚 Validating tales data...');

    final listFile = File('$rootPath/data/4/tales/list.json');
    if (!listFile.existsSync()) {
      return; // Already reported in structure check
    }

    try {
      // Read and parse JSON
      final content = await listFile.readAsString();
      final jsonList = jsonDecode(content) as List<dynamic>;

      // Try to parse into TaleDto list
      final tales = <TaleDto>[];
      for (var i = 0; i < jsonList.length; i++) {
        try {
          final tale = TaleDto.fromJson(jsonList[i] as Map<String, dynamic>);
          tales.add(tale);
        } catch (e) {
          errors.add('❌ Failed to parse tale at index $i: $e');
        }
      }

      print('✅ Successfully parsed ${tales.length} tales');

      // Validate individual tale folders
      await _validateTaleFolders(tales);

      // Check for duplicate IDs
      _checkDuplicateIds(tales.map((t) => t.id).toList(), 'tales');
    } catch (e) {
      errors.add('❌ Failed to parse tales/list.json: $e');
    }
  }

  /// Validate individual tale folders
  Future<void> _validateTaleFolders(List<TaleDto> tales) async {
    final talesDir = Directory('$rootPath/data/4/tales');
    final entries = talesDir.listSync();

    // Get all numeric folders
    final folderIds = <int>[];
    for (final entry in entries) {
      if (entry is Directory) {
        final name = entry.path.split('/').last;
        final id = int.tryParse(name);
        if (id != null) {
          folderIds.add(id);
        }
      }
    }

    // Check each tale has a corresponding folder
    for (final tale in tales) {
      final taleDir = Directory('$rootPath/data/4/tales/${tale.id}');

      if (!taleDir.existsSync()) {
        errors.add('❌ Tale ${tale.id} (${tale.name}) has no folder');
        continue;
      }

      // Validate tale folder structure
      _validateTaleFolderStructure(tale, taleDir);
    }

    // Check for orphaned folders (folders without corresponding tale in list)
    for (final folderId in folderIds) {
      if (!tales.any((t) => t.id == folderId)) {
        errors.add('❌ Orphaned tale folder: $folderId (not in list.json)');
      }
    }

    print('✅ Validated ${tales.length} tale folders');
  }

  /// Validate individual tale folder structure
  void _validateTaleFolderStructure(TaleDto tale, Directory taleDir) {
    final hasAudioTag = tale.tags.contains(TaleTag.audio);
    final entries = taleDir.listSync();

    // Check for required img folder
    final imgDir = Directory('${taleDir.path}/img');
    if (!imgDir.existsSync()) {
      errors.add('❌ Tale ${tale.id} missing img/ folder');
      return;
    }

    // Check for audio folder if audio tag is present
    Directory? audioDir;
    if (hasAudioTag) {
      audioDir = Directory('${taleDir.path}/audio');
      if (!audioDir.existsSync()) {
        errors.add(
          '❌ Tale ${tale.id} has "audio" tag but audio/ folder is missing',
        );
      }
    }

    // Validate no unexpected files/folders in tale root
    for (final entry in entries) {
      final name = entry.path.split('/').last;
      if (entry is Directory) {
        if (name != 'img' && name != 'audio') {
          errors.add('❌ Unexpected folder in tales/${tale.id}: $name');
        }
      } else if (entry is File) {
        if (name == '.DS_Store') {
          entry.deleteSync();
        } else {
          errors.add('❌ Unexpected file in tales/${tale.id}: $name');
        }
      }
    }

    // Validate img folder structure
    _validateTaleImgFolder(tale.id, imgDir);

    // Validate audio folder structure if it exists
    if (audioDir != null && audioDir.existsSync()) {
      _validateTaleAudioFolder(tale.id, audioDir);
    } else if (!hasAudioTag) {
      // Check if there's an audio folder when there shouldn't be
      final audioFolder = Directory('${taleDir.path}/audio');
      if (audioFolder.existsSync()) {
        errors.add(
          '❌ Tale ${tale.id} has audio/ folder but no "audio" tag in tags',
        );
      }
    }
  }

  /// Validate tale img folder structure
  void _validateTaleImgFolder(int taleId, Directory imgDir) {
    final files = imgDir.listSync().where((e) => e is File).toList();
    final fileNames = files.map((f) => f.path.split('/').last).toList();

    // Parse image pairs (index.original.* and index.thumbnail.jpg)
    final originalImages = <int, String>{};
    final thumbnailImages = <int>{};

    for (final fileName in fileNames) {
      if (fileName == '.DS_Store') {
        File('${imgDir.path}/$fileName').deleteSync();
        continue;
      }

      // Check for thumbnail pattern: {index}.thumbnail.jpg
      final thumbnailMatch = RegExp(
        r'^(\d+)\.thumbnail\.jpg$',
      ).firstMatch(fileName);
      if (thumbnailMatch != null) {
        final index = int.parse(thumbnailMatch.group(1)!);
        thumbnailImages.add(index);
        continue;
      }

      // Check for original pattern: {index}.original.{ext}
      final originalMatch = RegExp(
        r'^(\d+)\.original\.(.+)$',
      ).firstMatch(fileName);
      if (originalMatch != null) {
        final index = int.parse(originalMatch.group(1)!);
        final ext = originalMatch.group(2)!;
        originalImages[index] = ext;
        continue;
      }

      // Unexpected file
      errors.add('❌ Unexpected file in tales/$taleId/img: $fileName');
    }

    // Check for at least one image pair with index 0
    if (!originalImages.containsKey(0)) {
      errors.add('❌ Tale $taleId img/ folder missing 0.original.* file');
    }
    if (!thumbnailImages.contains(0)) {
      errors.add('❌ Tale $taleId img/ folder missing 0.thumbnail.jpg file');
    }

    // Check that all originals have corresponding thumbnails and vice versa
    final allIndices = {...originalImages.keys, ...thumbnailImages}.toList()
      ..sort();

    for (final index in allIndices) {
      if (!originalImages.containsKey(index)) {
        errors.add(
          '❌ Tale $taleId img/ has $index.thumbnail.jpg but missing $index.original.*',
        );
      }
      if (!thumbnailImages.contains(index)) {
        errors.add(
          '❌ Tale $taleId img/ has $index.original.${originalImages[index]} but missing $index.thumbnail.jpg',
        );
      }
    }

    // Check for sequential indices starting from 0
    if (allIndices.isNotEmpty) {
      for (var i = 0; i < allIndices.length; i++) {
        if (allIndices[i] != i) {
          errors.add(
            '❌ Tale $taleId img/ has non-sequential image indices. Expected $i, found ${allIndices[i]}',
          );
          break;
        }
      }
    }
  }

  /// Validate tale audio folder structure
  void _validateTaleAudioFolder(int taleId, Directory audioDir) {
    final files = audioDir.listSync().where((e) => e is File).toList();
    final fileNames = files.map((f) => f.path.split('/').last).toList();

    var hasThumbnailM4a = false;
    var hasOriginal = false;

    for (final fileName in fileNames) {
      if (fileName == '.DS_Store') {
        File('${audioDir.path}/$fileName').deleteSync();
        continue;
      }

      if (fileName == 'thumbnail.m4a') {
        hasThumbnailM4a = true;
      } else if (fileName.startsWith('original.')) {
        hasOriginal = true;
      } else {
        errors.add('❌ Unexpected file in tales/$taleId/audio: $fileName');
      }
    }

    if (!hasOriginal) {
      errors.add('❌ Tale $taleId audio/ folder missing original audio file');
    }
    if (!hasThumbnailM4a) {
      errors.add('❌ Tale $taleId audio/ folder missing thumbnail.m4a');
    }
  }

  /// Check for duplicate IDs
  void _checkDuplicateIds(List<int> ids, String type) {
    final seen = <int>{};
    final duplicates = <int>{};

    for (final id in ids) {
      if (seen.contains(id)) {
        duplicates.add(id);
      } else {
        seen.add(id);
      }
    }

    if (duplicates.isNotEmpty) {
      errors.add('❌ Duplicate IDs in $type: ${duplicates.join(', ')}');
    }
  }

  /// Validate file structure consistency
  Future<void> _validateFileStructure() async {
    print('\n🗂️  Validating file structure consistency...');

    // Validate people folder structure matches data/3 pattern
    await _validatePeopleFolderStructure();

    // Validate tales folder structure matches data/3 pattern
    await _validateTalesFolderStructure();
  }

  /// Validate people folder structure consistency
  Future<void> _validatePeopleFolderStructure() async {
    final peopleDir = Directory('$rootPath/data/4/people');
    if (!peopleDir.existsSync()) return;

    final entries = peopleDir.listSync();
    var validFolders = 0;

    for (final entry in entries) {
      if (entry is Directory) {
        final name = entry.path.split('/').last;
        final id = int.tryParse(name);

        if (id != null) {
          final files = entry.listSync();
          final fileNames = files.map((f) => f.path.split('/').last).toList();

          // Expected files: photo.thumbnail.jpg, photo.original.*
          final hasThumbnail = fileNames.contains('photo.thumbnail.jpg');
          final hasOriginal = fileNames.any(
            (f) => f.startsWith('photo.original.'),
          );

          if (hasThumbnail || hasOriginal) {
            validFolders++;
          }

          // Check for unexpected files - should only have thumbnail and original
          for (final fileName in fileNames) {
            if (fileName != 'photo.thumbnail.jpg' &&
                !fileName.startsWith('photo.original.')) {
              errors.add('❌ Unexpected file in people/$id: $fileName');
            }
          }

          // Verify exactly 2 files (thumbnail + original)
          final validFiles = fileNames
              .where(
                (f) =>
                    f == 'photo.thumbnail.jpg' ||
                    f.startsWith('photo.original.'),
              )
              .length;
          if (validFiles != 2) {
            errors.add(
              '❌ Person $id folder should have exactly 2 files (photo.thumbnail.jpg and photo.original.*), found $validFiles valid files',
            );
          }
        }
      }
    }

    print('✅ People folder structure validated ($validFolders valid folders)');
  }

  /// Validate tales folder structure consistency
  Future<void> _validateTalesFolderStructure() async {
    final talesDir = Directory('$rootPath/data/4/tales');
    if (!talesDir.existsSync()) return;

    final entries = talesDir.listSync();
    var validFolders = 0;

    for (final entry in entries) {
      if (entry is Directory) {
        final name = entry.path.split('/').last;
        final id = int.tryParse(name);

        if (id != null) {
          final subdirs = entry.listSync();
          final hasImgDir = subdirs.any(
            (f) => f is Directory && f.path.endsWith('img'),
          );

          if (hasImgDir) {
            validFolders++;
          }
        }
      }
    }

    print('✅ Tales folder structure validated ($validFolders valid folders)');
  }

  /// Validate compressed files exist and match uncompressed versions
  Future<void> _validateCompressedFiles() async {
    print('\n🗜️  Validating compressed files...');

    await _validateCompressedTales();
    await _validateCompressedPeople();
  }

  /// Validate compressed tales file
  Future<void> _validateCompressedTales() async {
    final listFile = File('$rootPath/data/4/tales/list.json');
    final compressedFile = File('$rootPath/data/4/tales/list.json.gz');

    if (!compressedFile.existsSync()) {
      errors.add('❌ Compressed tales file missing: list.json.gz');
      return;
    }

    try {
      // Read and parse original JSON
      final originalContent = await listFile.readAsString();
      final originalJson = jsonDecode(originalContent) as List<dynamic>;
      final originalTales = originalJson
          .map((json) => TaleDto.fromJson(json as Map<String, dynamic>))
          .toList();

      // Decompress and parse compressed file
      final compressedBytes = await compressedFile.readAsBytes();
      final decompressedTales = DTOCompression.decompressTales(compressedBytes);

      // Compare counts
      if (originalTales.length != decompressedTales.length) {
        errors.add(
          '❌ Tales count mismatch: original has ${originalTales.length}, compressed has ${decompressedTales.length}',
        );
        return;
      }

      // Compare each tale using Equatable
      for (var i = 0; i < originalTales.length; i++) {
        final original = originalTales[i];
        final decompressed = decompressedTales[i];

        if (original != decompressed) {
          errors.add(
            '❌ Tale mismatch at index $i (id=${original.id}): objects are not equal',
          );
        }
      }

      print(
        '✅ Compressed tales file validated (${decompressedTales.length} tales)',
      );
    } catch (e) {
      errors.add('❌ Failed to validate compressed tales file: $e');
    }
  }

  /// Validate compressed people file
  Future<void> _validateCompressedPeople() async {
    final listFile = File('$rootPath/data/4/people/list.json');
    final compressedFile = File('$rootPath/data/4/people/list.json.gz');

    if (!compressedFile.existsSync()) {
      errors.add('❌ Compressed people file missing: list.json.gz');
      return;
    }

    try {
      // Read and parse original JSON
      final originalContent = await listFile.readAsString();
      final originalJson = jsonDecode(originalContent) as List<dynamic>;
      final originalPeople = originalJson
          .map((json) => PersonDto.fromJson(json as Map<String, dynamic>))
          .toList();

      // Decompress and parse compressed file
      final compressedBytes = await compressedFile.readAsBytes();
      final decompressedPeople = DTOCompression.decompressPeople(
        compressedBytes,
      );

      // Compare counts
      if (originalPeople.length != decompressedPeople.length) {
        errors.add(
          '❌ People count mismatch: original has ${originalPeople.length}, compressed has ${decompressedPeople.length}',
        );
        return;
      }

      // Compare each person using Equatable
      for (var i = 0; i < originalPeople.length; i++) {
        final original = originalPeople[i];
        final decompressed = decompressedPeople[i];

        if (original != decompressed) {
          errors.add(
            '❌ Person mismatch at index $i (id=${original.id}): objects are not equal',
          );
        }
      }

      print(
        '✅ Compressed people file validated (${decompressedPeople.length} people)',
      );
    } catch (e) {
      errors.add('❌ Failed to validate compressed people file: $e');
    }
  }
}

/// Result of validation
class ValidationResult {
  final bool success;
  final List<String> errors;

  ValidationResult({required this.success, required this.errors});

  void printReport() {
    if (errors.isNotEmpty) {
      print('\n❌ ERRORS:');
      for (final error in errors) {
        print('  $error');
      }
    }
  }
}
