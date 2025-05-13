import 'package:dto/dto.dart';
import 'package:migration/migration/from_3_to_3/add_item/add_tale_helper.dart';
import 'package:migration/migration/from_3_to_3/from_3_to_3.dart';

class PrepareTalesForProdHelper extends AddTaleHelper {
  PrepareTalesForProdHelper(From3to3 migration)
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
              updateDate: null,
              summary: e.summary,
              tags: e.tags,
              text: e.text,
              audio: e.audio,
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
