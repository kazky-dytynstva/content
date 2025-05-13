import 'package:migration/migration/from_0_to_1/from_0_to_1.dart';
import 'package:migration/migration/base_migration.dart';
import 'package:migration/migration/from_2_to_2/from_2_to_2.dart';
import 'package:migration/migration/from_3_to_3/from_3_to_3.dart';

void main() async {
  final migrationsList = <BaseDataMigration>[
    // From0to1(),
    From2to2(),
    From3to3(),
  ];

  await migrationsList.last.run();
}
