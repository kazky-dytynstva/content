import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class ChapterAudioDto {
  /// In bytes
  final int size;

  /// In milliseconds
  final int duration;

  ChapterAudioDto({
    required this.size,
    required this.duration,
  });

  factory ChapterAudioDto.fromJson(Map<String, dynamic> json) =>
      _$ChapterAudioDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterAudioDtoToJson(this);
}
