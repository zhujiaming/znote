import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'entity/auth_ret.dart';

class Store {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const keyAuthInfo = "auth_info";

  Future<AuthInfo?> getAuthInfo() async {
    String? authInfoString = (await _prefs).getString(keyAuthInfo);
    if (authInfoString != null) {
      return AuthInfo.fromJson(json.decode(authInfoString));
    } else {
      return null;
    }
  }

  saveAuthInfo(AuthInfo ret) async {
    await (await _prefs).setString(keyAuthInfo, json.encode(ret.toJson()));
  }
}
