import 'package:dto/dto.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:migration/operation/operation.dart';

abstract class TaleOperation extends Operation<TaleDto> {
  TaleOperation(OperationType operationType)
      : super(
          operationType,
          ContentType.tale,
        );

  @override
  TaleDto itemFromJson(Map<String, dynamic> json) {
    return TaleDto.fromJson(json);
  }

  @override
  Map<String, dynamic> itemToJson(TaleDto item) {
    return item.toJson();
  }

  @override
  IList<TaleDto> modify(IList<TaleDto> list) {
    switch (operationType) {
      case OperationType.add:
        return _handleAdd(list);
      case OperationType.edit:
        return _handleEdit(list);
    }
  }

  TaleDto getNew({required int newTaleId}) {
    throw UnimplementedError();
  }

  TaleDto? getEdited(TaleDto original) {
    throw UnimplementedError();
  }

  IList<TaleDto> _handleAdd(IList<TaleDto> list) {
    final nextId = _getNextId(list);
    final item = getNew(newTaleId: nextId);

    logger.info('Preparation of new tale is done. New taleId : $nextId');

    return list.add(item);
  }

  IList<TaleDto> _handleEdit(IList<TaleDto> list) {
    return list.map((original) {
      final edited = getEdited(original);
      if (edited == null) return original;
      logger.info('Edit tale done. Edited taleId : ${edited.id}');
      return edited;
    }).toIList();
  }

  @override
  Exception? validate(IList<TaleDto> list) {
    final duplicates = _findDuplicates(list);

    if (duplicates.isEmpty) return null;

    return Exception('Looks like we have duplicates: $duplicates');
  }

  List<TaleDto> _findDuplicates(IList<TaleDto> list) {
    final seenIds = <int>{};
    final duplicates = <TaleDto>[];

    for (var obj in list) {
      if (seenIds.contains(obj.id)) {
        duplicates.add(obj);
      } else {
        seenIds.add(obj.id);
      }
    }

    return duplicates;
  }

  int _getNextId(IList<TaleDto> list) {
    int biggestId = 0;

    for (var obj in list) {
      if (obj.id > biggestId) {
        biggestId = obj.id;
      }
    }

    return biggestId + 1;
  }
}
