import 'package:json_annotation/json_annotation.dart';

part 'person_dto.g.dart';

@JsonSerializable()
class PersonDto {
  final int id;
  final String name;
  final String? url;
  final String? info;

  PersonDto({
    required this.id,
    required this.name,
    this.info,
    this.url,
  })  : assert(name.length >= 4),
        assert(id >= 0),
        assert(
          url == null ||
              url.isNotEmpty && Uri.tryParse(url)?.hasAbsolutePath == true,
        ),
        assert(info == null || info.isNotEmpty && info.length <= 100);

  factory PersonDto.fromJson(Map<String, dynamic> json) =>
      _$PersonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PersonDtoToJson(this);
}
