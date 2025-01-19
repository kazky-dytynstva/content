import 'package:dto/dto.dart';
import 'package:migration/migration/from_2_to_2/add_item/add_person_herlper.dart';
import 'package:migration/migration/from_2_to_2/add_item/add_tale_helper.dart';

class UpdatePeopleRoles {
  UpdatePeopleRoles({
    required AddTaleHelper addTaleHelper,
    required AddPersonHelper addPersonHelper,
  })  : _addTalesHelper = addTaleHelper,
        _addPersonHelper = addPersonHelper;

  final AddTaleHelper _addTalesHelper;
  final AddPersonHelper _addPersonHelper;

  Future<void> update() async {
    final tales = await _addTalesHelper.getAll();

    final personPersonRoleDtos = _mapPeoplePersonRoleDtos(tales);

    final allPeople = await _addPersonHelper.getAll();

    _populatePeopleRoles(allPeople, personPersonRoleDtos);

    await _addPersonHelper.saveJson(allPeople);
  }

  void _populatePeopleRoles(
    List<PersonDto> allPeople,
    Map<int, List<PersonRoleDto>> personPersonRoleDtos,
  ) {
    for (var person in allPeople) {
      final roles = personPersonRoleDtos[person.id];
      if (roles == null) continue;
      person.roles.clear();
      person.roles.addAll(roles);
    }
  }

  Map<int, List<PersonRoleDto>> _mapPeoplePersonRoleDtos(List<TaleDto> tales) {
    // Initialize a map to hold the result.
    Map<int, List<PersonRoleDto>> personPersonRoleDtos = {};

    for (var tale in tales) {
      for (var authorId in tale.crew?.authors ?? []) {
        personPersonRoleDtos
            .putIfAbsent(authorId, () => [])
            .add(PersonRoleDto.author);
      }
      for (var readerId in tale.crew?.readers ?? []) {
        personPersonRoleDtos
            .putIfAbsent(readerId, () => [])
            .add(PersonRoleDto.reader);
      }
      for (var translatorId in tale.crew?.translators ?? []) {
        personPersonRoleDtos
            .putIfAbsent(translatorId, () => [])
            .add(PersonRoleDto.translator);
      }

      for (var musicianId in tale.crew?.musicians ?? []) {
        personPersonRoleDtos
            .putIfAbsent(musicianId, () => [])
            .add(PersonRoleDto.musician);
      }

      for (var graphicId in tale.crew?.graphics ?? []) {
        personPersonRoleDtos
            .putIfAbsent(graphicId, () => [])
            .add(PersonRoleDto.graphic);
      }
    }

    // Ensure PersonRoleDtos are unique for each person.
    for (var entryKey in personPersonRoleDtos.keys) {
      final value = personPersonRoleDtos[entryKey]!;
      personPersonRoleDtos[entryKey] = value.toSet().toList();
    }

    return personPersonRoleDtos;
  }
}
