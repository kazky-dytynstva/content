import 'dart:io';
import 'dart:convert';

void main() async {
  final dir = Directory(
    '/Users/andrii.antonov/dev/kazky/content/data/4/tales/',
  );

  final children = dir.listSync().whereType<Directory>().toList();

  var processedCount = 0;
  final failedFiles = <String>[];

  print('Finalizing thumbnails: replacing with AAC versions...\n');

  for (final dir in children) {
    final id = dir.path.split('/').last;

    final audioDir = Directory('${dir.path}/audio/');
    if (!audioDir.existsSync()) continue;

    final thumbnailPath = '${audioDir.path}/thumbnail.m4a';
    final thumbnailRealPath = '${audioDir.path}/thumbnail_real.m4a';

    final thumbnailFile = File(thumbnailPath);
    final thumbnailRealFile = File(thumbnailRealPath);

    // Check if thumbnail_real.m4a exists
    if (thumbnailRealFile.existsSync()) {
      try {
        // Delete old thumbnail.m4a if it exists
        if (thumbnailFile.existsSync()) {
          thumbnailFile.deleteSync();
          print('Tale $id: Deleted old thumbnail.m4a');
        }

        // Rename thumbnail_real.m4a to thumbnail.m4a
        thumbnailRealFile.renameSync(thumbnailPath);
        print('Tale $id: Renamed thumbnail_real.m4a → thumbnail.m4a');
        print('');

        processedCount++;
      } catch (e) {
        print('Tale $id: ✗ Failed to process - $e');
        print('');
        failedFiles.add(id);
      }
    }
  }

  // Print summary
  print('=' * 80);
  print('FINALIZATION SUMMARY');
  print('=' * 80);
  print('Successfully processed: $processedCount tale(s)');

  if (failedFiles.isNotEmpty) {
    print('Failed: ${failedFiles.length} tale(s)');
    for (final id in failedFiles) {
      print('  - Tale $id');
    }
  } else {
    print('✓ All files processed successfully');
  }
  print('=' * 80);
}
