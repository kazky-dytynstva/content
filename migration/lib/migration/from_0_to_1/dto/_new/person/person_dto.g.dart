// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonDto _$PersonDtoFromJson(Map<String, dynamic> json) => PersonDto(
      id: json['id'] as int,
      name: json['name'] as String,
      info: json['info'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$PersonDtoToJson(PersonDto instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
  writeNotNull('info', instance.info);
  return val;
}
