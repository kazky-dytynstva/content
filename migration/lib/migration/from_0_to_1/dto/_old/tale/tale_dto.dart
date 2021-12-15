import 'package:json_annotation/json_annotation.dart';

import 'tale_crew_ids_dto.dart';

part 'tale_dto.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class TaleDto {
  final int id;
  final String name;
  final int createDate;
  final String? text;
  final TaleCrewIdsDto? crewIds;
  final bool? lullaby, hasAudio;

  TaleDto({
    required this.id,
    required this.name,
    required this.createDate,
    this.text,
    this.crewIds,
    this.lullaby,
    this.hasAudio,
  });

  factory TaleDto.fromJson(Map<String, dynamic> json) =>
      _$TaleDtoFromJson(json);
}
