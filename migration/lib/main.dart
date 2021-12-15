import 'package:migration/migration/from_0_to_1/from_0_to_1.dart';
import 'package:migration/migration/base_migration.dart';

void main() async {
  final migrationsList = <BaseDataMigration>[
    From0to1(),
  ];

  await migrationsList.last.run();
}
