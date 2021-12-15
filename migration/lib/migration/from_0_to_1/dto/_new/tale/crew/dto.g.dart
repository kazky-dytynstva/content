// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaleCrewDto _$TaleCrewDtoFromJson(Map<String, dynamic> json) => TaleCrewDto(
      authors:
          (json['authors'] as List<dynamic>?)?.map((e) => e as int).toList(),
      readers:
          (json['readers'] as List<dynamic>?)?.map((e) => e as int).toList(),
      musicians:
          (json['musicians'] as List<dynamic>?)?.map((e) => e as int).toList(),
      translators: (json['translators'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      graphics:
          (json['graphics'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$TaleCrewDtoToJson(TaleCrewDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('authors', instance.authors);
  writeNotNull('readers', instance.readers);
  writeNotNull('musicians', instance.musicians);
  writeNotNull('translators', instance.translators);
  writeNotNull('graphics', instance.graphics);
  return val;
}
