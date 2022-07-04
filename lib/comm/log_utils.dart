class LogUtil {
  static bool _isDebug = false;

  static init({bool isDebug = false}) {
    _isDebug = isDebug;
  }

  static d(Object? printMessage) {
    print(printMessage);
  }

  static e(Object? error) {
    print(error);
  }
}
