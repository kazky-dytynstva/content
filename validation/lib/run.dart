import 'dart:io';

void main() async {
  final dir = Directory(
    '/Users/andrii.antonov/dev/kazky/content/data/4/tales/',
  );

  final service = TrimAudioService();
  final children = dir.listSync().whereType<Directory>().toList();

  var totalOldSize = 0;
  var totalNewSize = 0;

  for (final dir in children) {
    final id = dir.path.split('/').last;
    print('Processing $id');
    if (id == '0') {
      id.toString();
    }

    final audioDir = Directory('${dir.path}/audio/');
    if (!audioDir.existsSync()) continue;

    final files = audioDir.listSync().whereType<File>().toList();

    final originalAudio = files.firstWhere(
      (file) => file.path.contains('original.'),
      orElse: () => throw Exception('Original audio not found in $id'),
    );
    final thumbnailFile = files.firstWhere(
      (file) => file.path.contains('thumbnail.'),
      orElse: () => throw Exception('Thumbnail audio not found in $id'),
    );

    if (thumbnailFile.path.endsWith('.m4a')) {
      print('  Skipping $id, already in m4a format\n');
      continue;
    }

    if (id == '142' || id == '91' || id == '224') {
      print('  Skipping $id due to known issue\n');
      continue;
    }

    // Get old thumbnail size
    final oldSize = thumbnailFile.lengthSync();
    totalOldSize += oldSize;

    final newThumbnailFile = await service.run(originalAudio: originalAudio);

    // Get new thumbnail size
    final newSize = newThumbnailFile.lengthSync();

    if (newSize > oldSize) {
      newThumbnailFile.deleteSync();
      newThumbnailFile.createSync();

      newThumbnailFile.writeAsBytesSync(thumbnailFile.readAsBytesSync());
      thumbnailFile.deleteSync();
      print('  Reverted to original thumbnail for $id as new size is larger\n');
      continue;
    }

    thumbnailFile.deleteSync();

    totalNewSize += newSize;

    final difference = newSize - oldSize;
    final sign = difference >= 0 ? '+' : '';
    print('  Old: ${_formatBytes(oldSize)}');
    print('  New: ${_formatBytes(newSize)}');
    print('  Diff: $sign${_formatBytes(difference)}');
    print('Processed $id\n');
  }

  final totalDifference = totalNewSize - totalOldSize;
  final totalSign = totalDifference >= 0 ? '+' : '';
  print('=' * 50);
  print('TOTAL SUMMARY:');
  print('  Total old size: ${_formatBytes(totalOldSize)}');
  print('  Total new size: ${_formatBytes(totalNewSize)}');
  print('  Total difference: $totalSign${_formatBytes(totalDifference)}');
  print('=' * 50);
}

String _formatBytes(int bytes) {
  final absBytes = bytes.abs();
  final sign = bytes < 0 ? '-' : '';
  if (absBytes < 1024) return '$sign$absBytes B';
  if (absBytes < 1024 * 1024) {
    return '$sign${(absBytes / 1024).toStringAsFixed(2)} KB';
  }
  return '$sign${(absBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
}

const _defaultBitrateKbps = 80;

class TrimAudioService {
  TrimAudioService();

  /// Compresses and crops audio file
  ///
  /// [originalAudio] - The original audio file to process
  /// [startTime] - Start time for cropping
  /// [endTime] - End time for cropping
  ///
  /// Returns [AudioData] with the processed audio file in M4A format
  Future<File> run({required File originalAudio}) async {
    final outputFileName = 'thumbnail.m4a';
    final outputPath = originalAudio.parent.path + '/' + outputFileName;

    // Build FFmpeg command for trimming and converting to M4A
    // -i: input file
    // -ss: start time
    // -to: end time
    // -ac: audio channels (1 = mono)
    // -ar: audio sample rate
    // -b:a: audio bitrate
    // -c:a: audio codec (aac for m4a)
    // -y: overwrite output file

    final arguments = [
      '-i',
      originalAudio.path,
      '-ac',
      '1',
      '-ar',
      '44100',
      '-b:a',
      '${_defaultBitrateKbps}k',
      '-c:a',
      'aac',
      '-y',
      outputPath,
    ];

    // Execute ffmpeg command using Process.run
    // Assumes ffmpeg is installed and available in PATH
    final result = await Process.run('ffmpeg', arguments);

    if (result.exitCode != 0) {
      final errorOutput = result.stderr.toString();
      throw Exception('Помилка обробки аудіо: $errorOutput');
    }

    final outputFile = File(outputPath);
    if (!await outputFile.exists()) {
      throw Exception('Вихідний файл не створено після обробки');
    }

    return outputFile;
  }
}
