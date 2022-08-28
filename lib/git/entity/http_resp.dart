import 'package:znote/main.dart';

class Resp {
  int code = 0;
  String message = '';
  dynamic data;

  bool get isSuccess => code == 0;

  static success(dynamic data) => Resp()..data = data;

  static error(int code, [String message = '', dynamic data]) => Resp()
    ..code = code
    ..message = message
    ..data = data;

  void showToastIf() {
    if (!isSuccess) {
      if (code == 401) {
        showToast("请重新登录");
      } else {
        showToast(message.isEmpty
            ? 'response error:$code'
            : "response error:$message,$code");
      }
    }
  }
}
