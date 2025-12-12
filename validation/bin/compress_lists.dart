import 'dart:convert';
import 'dart:io';
import 'package:dto/dto.dart';

Future<void> main() async {
  final rootPath = Directory.current.parent.path;

  print('🗜️  Compressing list.json files...\n');

  // Compress tales
  await _compressTales(rootPath);

  // Compress people
  await _compressPeople(rootPath);

  print('\n✅ Compression complete!');
}

Future<void> _compressTales(String rootPath) async {
  final listFile = File('$rootPath/data/4/tales/list.json');
  final compressedFile = File('$rootPath/data/4/tales/list.json.gz');

  if (!listFile.existsSync()) {
    print('❌ Tales list.json not found');
    return;
  }

  // Read and parse JSON
  final content = await listFile.readAsString();
  final jsonList = jsonDecode(content) as List<dynamic>;
  final tales = jsonList
      .map((json) => TaleDto.fromJson(json as Map<String, dynamic>))
      .toList();

  // Compress
  final compressed = DTOCompression.compressTales(tales);

  // Write compressed file
  await compressedFile.writeAsBytes(compressed);

  final originalSize = await listFile.length();
  final compressedSize = compressed.length;
  final ratio = ((1 - compressedSize / originalSize) * 100).toStringAsFixed(1);

  print('📚 Tales:');
  print('   Original:   ${_formatBytes(originalSize)}');
  print('   Compressed: ${_formatBytes(compressedSize)}');
  print('   Ratio:      $ratio% reduction');
}

Future<void> _compressPeople(String rootPath) async {
  final listFile = File('$rootPath/data/4/people/list.json');
  final compressedFile = File('$rootPath/data/4/people/list.json.gz');

  if (!listFile.existsSync()) {
    print('❌ People list.json not found');
    return;
  }

  // Read and parse JSON
  final content = await listFile.readAsString();
  final jsonList = jsonDecode(content) as List<dynamic>;
  final people = jsonList
      .map((json) => PersonDto.fromJson(json as Map<String, dynamic>))
      .toList();

  // Compress
  final compressed = DTOCompression.compressPeople(people);

  // Write compressed file
  await compressedFile.writeAsBytes(compressed);

  final originalSize = await listFile.length();
  final compressedSize = compressed.length;
  final ratio = ((1 - compressedSize / originalSize) * 100).toStringAsFixed(1);

  print('👥 People:');
  print('   Original:   ${_formatBytes(originalSize)}');
  print('   Compressed: ${_formatBytes(compressedSize)}');
  print('   Ratio:      $ratio% reduction');
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
