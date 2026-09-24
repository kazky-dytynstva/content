import 'dart:io';

import 'package:validation/validate_data_4.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length > 1) {
    stderr.writeln('Usage: dart run bin/validate_data_4.dart [content-root]');
    exitCode = 64;
    return;
  }
  final rootPath = arguments.isEmpty
      ? Directory.current.parent.path
      : Directory(arguments.single).absolute.path;

  print('Root path: $rootPath\n');

  final validator = Data4Validator(rootPath);
  final result = await validator.validate();

  result.printReport();

  // Exit with error code if validation failed
  if (!result.success) {
    exit(1);
  }
}
