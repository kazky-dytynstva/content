import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class TaleCrewDto {
  final List<int>? authors;
  final List<int>? readers;
  final List<int>? musicians;
  final List<int>? translators;
  final List<int>? graphics;

  TaleCrewDto({
    required this.authors,
    required this.readers,
    required this.musicians,
    required this.translators,
    required this.graphics,
  }) : assert(
          (authors?.isNotEmpty == true) ||
              (readers?.isNotEmpty == true) ||
              (musicians?.isNotEmpty == true) ||
              (translators?.isNotEmpty == true) ||
              (graphics?.isNotEmpty == true),
          'There should be at least one notEmpty list',
        );

  factory TaleCrewDto.fromJson(Map<String, dynamic> json) =>
      _$TaleCrewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaleCrewDtoToJson(this);
}
