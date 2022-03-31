import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/person/person_dto.dart';

import '../base_migration.dart';

class From2to2 extends BaseDataMigration {
  @override
  int get appBuildNumberOld => 149;

  @override
  String get appVersionOld => '5.0.0';

  @override
  int get dataVersionOld => 2;

  @override
  int get dataVersionNew => 2;

  @override
  bool get canCleanNewDirectory => false;

  @override
  Future<bool> migrate() async {
    final addOk = await _AddPersonHelper(this).run();
    return addOk;
  }
}

abstract class _AddHelper {
  final From2to2 migration;

  String get addItemName;

  _AddHelper(this.migration);

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

  Future<void> revert();
}

class _AddPersonHelper extends _AddHelper {
  _AddPersonHelper(From2to2 migration) : super(migration);

  @override
  String get addItemName => 'Person';

  String get peopleDataPath => '${migration.dataPathOld}/people';

  String get peopleJsonPath => '$peopleDataPath/list.json';

  late int nextPersonId;

  final List<PersonDto> originalPeople = [];

  @override
  Future<void> revert() async {
    await savePeople(originalPeople);
  }

  @override
  Future<bool> validate({
    bool post = false,
  }) async {
    try {
      final people = await _getAllPeople();

      final peopleIds = people.map((e) => e.id).toSet();
      final peopleNames = people.map((e) => e.name).toSet();

      assert(
        peopleIds.length == peopleNames.length,
        'Looks like we have duplicate',
      );

      if (post) {
        final path = '$peopleDataPath/img/$nextPersonId.jpg';
        final file = File(path);
        assert(
          file.existsSync(),
          'Image for the person was not found',
        );
      }
      return true;
    } catch (e) {
      migration.log(e.toString());
      return false;
    }
  }

  @override
  Future<void> add() async {
    final lastPersonId = await _getLastPersonId();
    nextPersonId = lastPersonId + 1;

    final person = PersonDto(
      id: nextPersonId,
      name: 'Ніка Балаж',
      info:
          'Ілюстратор дитячого періодичного видання «Перший інтерактивний журнал для дітей Чарівний ліхтарик»',
    );
    final allPeople = await _getAllPeople();
    allPeople.add(person);
    await savePeople(allPeople);
  }

  Future<List<PersonDto>> _getAllPeople() async {
    final json = await migration.readJsonList(peopleJsonPath);
    final people = json.map((e) => PersonDto.fromJson(e)).toList();
    if (originalPeople.isEmpty) {
      originalPeople.addAll(people);
    }
    return people;
  }

  Future<int> _getLastPersonId() async {
    final people = (await _getAllPeople()).map((e) => e.id);
    return people.reduce(max);
  }

  Future<void> savePeople(List<PersonDto> people) async {
    final json = people.map((e) => e.toJson()).toList();
    await migration.saveJsonListToFile(data: json, filePath: peopleJsonPath);
  }
}
