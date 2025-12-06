import 'dart:io';
import 'package:validation/validate_data_4.dart';

Future<void> main() async {
  // Get the project root path (3 levels up from bin directory)
  final scriptDir = Directory.current.path;
  final rootPath = Directory(scriptDir).parent.path;

  print('Root path: $rootPath\n');

  final validator = Data4Validator(rootPath);
  final result = await validator.validate();

  result.printReport();

  // Exit with error code if validation failed
  if (!result.success) {
    exit(1);
  }
}
