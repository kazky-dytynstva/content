import 'dart:io';

import 'package:validation/mobile_delivery.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length != 2) {
    stderr.writeln(
      'Usage: build_mobile_delivery <content-root> <new-output-directory>',
    );
    exitCode = 64;
    return;
  }
  try {
    await MobileDelivery().build(
      Directory(arguments[0]),
      Directory(arguments[1]),
    );
  } catch (error) {
    stderr.writeln('Delivery blocked: $error');
    exitCode = 1;
  }
}
