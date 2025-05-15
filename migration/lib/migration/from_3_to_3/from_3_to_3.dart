import 'package:migration/migration/from_3_to_3/add_item/add_person_herlper.dart';
import 'package:migration/migration/from_3_to_3/add_item/add_tale_helper.dart';
import 'package:migration/migration/from_3_to_3/update_people_roles.dart';

import '../base_migration.dart';

/// This migration is not about migration,
/// but about filling the current database
class From3to3 extends BaseDataMigration {
  @override
  int get appBuildNumberOld => 149;

  @override
  String get appVersionOld => '5.0.0';

  @override
  int get dataVersionOld => 3;

  @override
  int get dataVersionNew => 3;

  @override
  bool get canCleanNewDirectory => false;

  @override
  Future<bool> migrate() async {
    final addPersonHelper = AddPersonHelper(this);
    final addTaleHelper = AddTaleHelper(this);

    final addPersonOk = await addPersonHelper.run(fastReturn: true);

    final addTaleOk = await addTaleHelper.run(fastReturn: false);

    await UpdatePeopleRoles(
      addTaleHelper: addTaleHelper,
      addPersonHelper: addPersonHelper,
    ).update();

    final prepareTalesForProdOk = true;
    // final prepareTalesForProdOk = await PrepareTalesForProdHelper(this).run();
    return addPersonOk && addTaleOk && prepareTalesForProdOk;
  }
}
