import 'dart:io';

import 'package:validation/branch_ids.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length != 4) {
    stderr.writeln(
      'Usage: validate_branch_ids <repository> <ancestor-sha> <base-sha> <head-sha>',
    );
    exitCode = 64;
    return;
  }
  try {
    await validateBranchIds(
      Directory(arguments[0]),
      arguments[1],
      arguments[2],
      arguments[3],
    );
  } catch (error) {
    stderr.writeln('ID validation blocked: $error');
    exitCode = 1;
  }
}
