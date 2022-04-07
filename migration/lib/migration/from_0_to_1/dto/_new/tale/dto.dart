import 'package:json_annotation/json_annotation.dart';
import 'package:migration/utils/to_json.dart';

import 'chapter/dto.dart';
import 'crew/dto.dart';

part 'dto.g.dart';

@JsonSerializable()
class TaleDto implements ToJson {
  final int id;
  final String name;
  final int createDate;
  final Set<String> tags;
  final List<TaleChapterDto> content;

  final TaleCrewDto? crew;
  final bool? ignore;

  TaleDto({
    required this.id,
    required this.name,
    required this.createDate,
    required this.tags,
    required this.content,
    required this.crew,
    this.ignore,
  })  : assert(
          content.isNotEmpty == true,
          'Content can not be empty',
        ),
        assert(
          tags.isNotEmpty,
          'There should be at least one tag',
        );

  factory TaleDto.fromJson(Map<String, dynamic> json) =>
      _$TaleDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TaleDtoToJson(this);
}
