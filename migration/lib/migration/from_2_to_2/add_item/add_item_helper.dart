import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/utils/to_json.dart';

abstract class AddItemHelper {
  final From2to2 migration;

  final String addItemName;
  final String folderName;

  late int nextId;

  AddItemHelper(
    this.migration, {
    required this.addItemName,
    required this.folderName,
  });

  final List<ToJson> originalList = [];

  String get dataPath => '${migration.dataPathOld}/$folderName';

  String get jsonPath => '$dataPath/list.json';

  Future<bool> run() async {
    migration.log('Add new $addItemName started ⏱');
    migration.log('   - pre validation started');
    assert(await validate());
    migration.log('   - pre validation done');
    await add();
    migration.log('   - add item - done');
    migration.log('   - post validation started');
    final addOk = await validate(post: true);
    if (addOk) {
      migration.log('   - post validation done');
      migration.log('New $addItemName was added successfully ☑️');
    } else {
      migration.log('   - post validation failed');
      await revert();
      migration.log('   - changes reverted');
      migration.log('New $addItemName was NOT added successfully 🛑️');
    }
    return addOk;
  }

  Future<void> add();

  Future<bool> validate({bool post = false});

  Future<void> revert() async {
    await saveJson(originalList);
  }

  Future<void> saveJson(List<ToJson> list) async {
    list.sort((a, b) => b.id.compareTo(a.id));
    final json = list.map((e) => e.toJson()).toList();
    await migration.saveJsonListToFile(data: json, filePath: jsonPath);
  }
}
