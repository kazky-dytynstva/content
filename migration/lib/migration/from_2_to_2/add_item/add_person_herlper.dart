import 'dart:io';
import 'dart:math';

import 'package:migration/migration/from_0_to_1/dto/_new/person/person_dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/base_add_helper.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';

class AddPersonHelper extends _AddPersonHelper {
  AddPersonHelper(From2to2 migration) : super(migration);

  @override
  String get name => 'Анна Чернявська';

  @override
  String? get info => 'Письменниця-початківець, громадська діячка, учителька';

  @override
  String? get url => 'https://www.instagram.com/anna_cherniavska9';
}

abstract class _AddPersonHelper extends BaseAddHelper {
  _AddPersonHelper(From2to2 migration)
      : super(
          migration,
          addItemName: 'Person',
          folderName: 'people',
        );

  @override
  Future<bool> validate({
    bool post = false,
  }) async {
    try {
      final all = await _getAll();

      final idList = all.map((e) => e.id).toSet();
      final nameList = all.map((e) => e.name).toSet();

      assert(
        idList.length == nameList.length,
        'Looks like we have duplicate',
      );
      assert(
        idList.length == all.length,
        'Looks like we have duplicate',
      );

      if (post) {
        final path = '$dataPath/img/$nextId.jpg';
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

  String get name;

  String? get info;

  String? get url;

  @override
  Future<void> add() async {
    nextId = (await _getLastId()) + 1;

    final person = PersonDto(
      id: nextId,
      name: name,
      info: info,
      url: url,
    );
    final allPeople = await _getAll();
    allPeople.add(person);
    await saveJson(allPeople);
  }

  Future<List<PersonDto>> _getAll() async {
    final json = await migration.readJsonList(jsonPath);
    final people = json.map((e) => PersonDto.fromJson(e)).toList();
    if (originalList.isEmpty) {
      originalList.addAll(people);
    }
    return people;
  }

  Future<int> _getLastId() async {
    final people = (await _getAll()).map((e) => e.id);
    return people.reduce(max);
  }
}
