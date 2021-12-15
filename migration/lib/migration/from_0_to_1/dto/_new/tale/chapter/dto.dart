import 'package:json_annotation/json_annotation.dart';

import 'audio/dto.dart';

part 'dto.g.dart';

@JsonSerializable()
class TaleChapterDto {
  final String? title;

  /// text might contain image references as a number
  /// one number per list item - mean this is the image reference
  ///
  /// for example
  ///
  /// 3 - mean that here should be inserted photo with id #3
  final List<String>? text;

  final ChapterAudioDto? audio;

  final int imagesCount;

  TaleChapterDto({
    required this.title,
    required this.text,
    required this.audio,
    required this.imagesCount,
  }) : assert(
          imagesCount >= 1,
          'There always should be at least one, main image',
        );

  factory TaleChapterDto.fromJson(Map<String, dynamic> json) =>
      _$TaleChapterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaleChapterDtoToJson(this);
}
