import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:znote/git/entity/auth_ret.dart';
import 'package:znote/git/requests.dart';

class GitLogic {
  GitLogic._();

  // static GitLogic get instance => _getInstance();
  static GitLogic? _instance;

  static GitLogic get() {
    return _instance ??= GitLogic._();
  }

  final Store _store = Store();

  ///
  /// 远端认证
  ///
  Future<bool> auth() async {
    AuthRet? loginRet = await _store.getAuthInfo();

    if (loginRet != null) {
      return true;
    } else {
      AuthRet? loginRet = await Requests.auth();
      if (loginRet != null) {
        _store.saveAuthInfo(loginRet);
      }
      return loginRet != null;
    }
  }
}

class Store {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const keyAuthInfo = "auth_info";

  Future<AuthRet?> getAuthInfo() async {
    String? authInfoString = (await _prefs).getString(keyAuthInfo);
    if (authInfoString != null) {
      return AuthRet.fromJson(json.decode(authInfoString));
    } else {
      return null;
    }
  }

  saveAuthInfo(AuthRet ret) async {
    await (await _prefs).setString(keyAuthInfo, json.encode(ret.toJson()));
  }
}
