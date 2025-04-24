import 'package:dto/dto.dart';
import 'package:migration/operation/operation.dart';
import 'package:migration/operation/tale/tale_operation.dart';

void main() {
  _EditTaleOperation().execute();
}

class _EditTaleOperation extends TaleOperation {
  _EditTaleOperation() : super(OperationType.edit);

  @override
  Future<void> fallback() async {}

  @override
  TaleDto? getEdited(TaleDto original) {
    if (original.id != 666) return null;
    return original.copyWith(name: '777');
  }
}

extension on TaleDto {
  TaleDto copyWith({
    String? name,
    DateTime? createDate,
    DateTime? updateDate,
    String? summary,
    Set<TaleTag>? tags,
    TextContentDto? text,
    AudioContentDto? audio,
    CrewDto? crew,
    bool? ignore,
  }) {
    return TaleDto(
      id: id,
      name: name ?? this.name,
      createDate: createDate?.millisecondsSinceEpoch ?? this.createDate,
      updateDate: updateDate?.millisecondsSinceEpoch ?? this.updateDate,
      summary: summary ?? this.summary,
      tags: tags ?? this.tags,
      text: text ?? this.text,
      audio: audio ?? this.audio,
      crew: crew ?? this.crew,
      ignore: ignore ?? this.ignore,
    );
  }
}
