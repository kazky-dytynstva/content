// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tale_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaleDto _$TaleDtoFromJson(Map<String, dynamic> json) => TaleDto(
      id: json['id'] as int,
      name: json['name'] as String,
      createDate: json['createDate'] as int,
      text: json['text'] as String?,
      crewIds: json['crewIds'] == null
          ? null
          : TaleCrewIdsDto.fromJson(json['crewIds'] as Map<String, dynamic>),
      lullaby: json['lullaby'] as bool?,
      hasAudio: json['hasAudio'] as bool?,
    );
