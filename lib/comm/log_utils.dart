import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class LogUtil {
  static bool _isDebug = false;

  static init({bool isDebug = false}) {
    _isDebug = isDebug;
  }

  static d(Object? printMessage) {
    logger.d(printMessage);
  }

  static e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(message, error, stackTrace);
  }
}
