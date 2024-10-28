import 'dart:io';
import 'package:mp3_info/mp3_info.dart';

AudioUtilData getAudioUtilData(String filePath) {
  final file = File(filePath);

  final info = MP3Processor.fromFile(file);
  return AudioUtilData(info.duration, file.lengthSync());
}

class AudioUtilData {
  final Duration duration;
  final int size;

  AudioUtilData(
    this.duration,
    this.size,
  );
}
