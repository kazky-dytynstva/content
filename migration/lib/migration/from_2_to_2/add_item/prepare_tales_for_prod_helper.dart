import 'package:migration/migration/from_2_to_2/add_item/add_tale_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';

import '../../from_0_to_1/dto/_new/tale/dto.dart';

class PrepareTalesForProdHelper extends AddTaleHelper {
  PrepareTalesForProdHelper(From2to2 migration)
      : super(
          migration,
        );

  int prepareTalesCount = 1;

  @override
  Future<void> add() async {
    final all = await getAll();
    final talesToPrepare = getTalesToPrepare(all);
    final prepared = prepareTales(talesToPrepare);
    final updated = getUpdateTales(all: all, prepared: prepared);
    await saveJson(updated);
  }

  @override
  Future<bool> validate({bool post = false}) async {
    try {
      final all = await getAll();

      final idList = all.map((e) => e.id).toSet();

      assert(
        idList.length == all.length,
        'Looks like we have duplicate',
      );
      return true;
    } catch (e) {
      migration.log(e.toString());
      return false;
    }
  }

  List<TaleDto> getTalesToPrepare(List<TaleDto> all) {
    final ignored = all.where((element) => element.ignore == true).toList();
    assert(
      ignored.length >= prepareTalesCount,
      "There is not enough tales to prepare...",
    );
    ignored.sort((a, b) => a.id.compareTo(b.id));

    return ignored.sublist(0, prepareTalesCount);
  }

  List<TaleDto> prepareTales(List<TaleDto> tales) {
    final now = DateTime.now();
    final ignore = null;
    return tales
        .map((e) => TaleDto(
              id: e.id,
              name: e.name,
              createDate: now.millisecondsSinceEpoch,
              tags: e.tags,
              content: e.content,
              crew: e.crew,
              ignore: ignore,
            ))
        .toList();
  }

  List<TaleDto> getUpdateTales({
    required List<TaleDto> all,
    required List<TaleDto> prepared,
  }) {
    for (final tale in prepared) {
      all.removeWhere((element) => element.id == tale.id);
      all.add(tale);
    }
    return all;
  }
}
