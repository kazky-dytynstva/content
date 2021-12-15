import 'package:json_annotation/json_annotation.dart';

part 'tale_crew_ids_dto.g.dart';

@JsonSerializable(createToJson: false)
class TaleCrewIdsDto {
  final List<int>? authors;
  final List<int>? readers;
  final List<int>? musicians;
  final List<int>? translators;
  final List<int>? graphics;

  TaleCrewIdsDto({
    this.authors,
    this.readers,
    this.musicians,
    this.translators,
    this.graphics,
  });

  factory TaleCrewIdsDto.fromJson(Map<String, dynamic> json) =>
      _$TaleCrewIdsDtoFromJson(json);
}
