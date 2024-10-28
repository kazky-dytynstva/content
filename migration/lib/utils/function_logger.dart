import 'package:fast_immutable_collections/fast_immutable_collections.dart';

const _red = '\x1B[31m';
const _green = '\x1B[32m';
const _yellow = '\x1b[33m';
const _reset = '\x1B[0m';

/// This constant is used as a key to set and get the value of
/// 'OBFUSCATED_TEST_RUN' from the environment variables.
const kEnvVarKeyObfuscatedRun = 'OBFUSCATED_TEST_RUN';

bool _isNullOrEmpty(dynamic value) {
  return value == null || (value is String && value.isEmpty);
}

/// A logger which collects information on what method is called and with what
/// args in order to print success or failure messages
class FunctionLogger {
  final Object? _classObject;
  final String _name;
  final IMap<String, dynamic> _args;

  /// Creates a new [FunctionLogger]
  ///
  /// [name] should be the name of the function
  /// [classObject] should be the [Object] from which [name] is being called
  /// [args] should be the key:value args passed to the function [name]
  FunctionLogger({
    required String name,
    Object? classObject,
    IMap<String, dynamic>? args,
  })  : _classObject = classObject,
        _name = name,
        _args = args ?? const IMapConst({});

  late final _methodStringClassPrefix = _classObject == null
      ? ''
      : '[$_classObject] ${_classObject.runtimeType}.';
  late final _methodString = '$_methodStringClassPrefix$_name'
      '(${_args.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ')})';
  late final _successMessage =
      '$_green(✅ SUCCESS)$_reset The execution of $_methodString succeeded';
  late final _failureMessage =
      '$_red(❌ FAILURE)$_reset The execution of $_methodString failed';
  late final _startMessage = 'The execution of $_methodString started';

  /// Prints a success message for this function call
  void success([String? message]) {
    final formattedMessage =
        _isNullOrEmpty(message) ? '' : '\nstdout:\n$message';
    print('$_successMessage$formattedMessage');
  }

  /// Prints the failure message and returns an exception representing the
  /// failure.
  Exception failure(
    String? message, {
    Object? stdout,
    Object? stderr,
  }) {
    final formattedMessage = message == null ? '' : '\nmessage: $message';
    final stdoutMessage = _isNullOrEmpty(stdout) ? '' : '\nstdout:\n$stdout';
    final stderrMessage = _isNullOrEmpty(stderr) ? '' : '\nstderr:\n$stderr';

    return Exception(
      '$_failureMessage$formattedMessage$stdoutMessage$stderrMessage',
    );
  }

  /// Prints a message to stdout to advise we have began this function call
  void start() {
    _printInfo(_startMessage);
  }

  /// Prints a [message] to stdout using the [_methodString]
  void info(String message, {bool prefixMethodString = true}) {
    _printInfo('${prefixMethodString ? '$_methodString: ' : ''}$message');
  }

  void _printInfo(String message) {
    print('$_yellow(ℹ️ INFO)$_reset $message');
  }
}
