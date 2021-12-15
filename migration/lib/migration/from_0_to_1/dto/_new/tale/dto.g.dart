// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaleDto _$TaleDtoFromJson(Map<String, dynamic> json) => TaleDto(
      id: json['id'] as int,
      name: json['name'] as String,
      createDate: json['create_date'] as int,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toSet(),
      content: (json['content'] as List<dynamic>)
          .map((e) => TaleChapterDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: json['crew'] == null
          ? null
          : TaleCrewDto.fromJson(json['crew'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaleDtoToJson(TaleDto instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'create_date': instance.createDate,
    'tags': instance.tags.toList(),
    'content': instance.content,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('crew', instance.crew);
  return val;
}
