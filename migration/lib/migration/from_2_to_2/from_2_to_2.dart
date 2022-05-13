import 'package:migration/migration/from_2_to_2/add_item/add_person_herlper.dart';
import 'package:migration/migration/from_2_to_2/add_item/add_tale_helper.dart';
import 'package:migration/migration/from_2_to_2/add_item/prepare_tales_for_prod_helper.dart';

import '../base_migration.dart';

/// This migration is not about migration,
/// but about filling the current database
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
    final addPersonOk = true ?? await AddPersonHelper(this).run();
    final addTaleOk = true ?? await AddTaleHelper(this).run();
    final prepareTalesForProdOk =
         await PrepareTalesForProdHelper(this).run();
    return addPersonOk && addTaleOk && prepareTalesForProdOk;
  }
}
