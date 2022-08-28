import 'package:dio/dio.dart';
import 'package:znote/git/engine.dart';
import 'package:znote/git/entity/auth_ret.dart';

class Requests {
  static Future<AuthRet?> auth() async {
    Response response = await Engine.post('https://gitee.com/oauth/token', {
      'grant_type': 'password',
      'username': 'ah_zjm@163.com',
      'password': 'zjm6253321',
      'client_id':
          '584f288684626a09db1098df1158845cd4de670fc2b013269fcc79cf411d9447',
      'client_secret':
          'ff4bd06b35b783d408258a17e5e198a7ccd058506cfd58c5597025e4dc6a3e78',
      'scope': 'projects gists',
    });

    int statusCode = response.statusCode ?? -1;
    if (statusCode == 200) {
      /// {
      /// "access_token":"85bec00aaaaf80d4cfe3c35dad4fc130"
      /// ,"token_type":"bearer"
      /// ,"expires_in":86400
      /// ,"refresh_token":"9cb37ddd9ad9f12f0ab89a89ed0983e7f056a0d5c969ea6603840527b7358725"
      /// ,"scope":"projects gists"
      /// ,"created_at":1661671164
      /// }

      AuthRet loginRet = AuthRet.fromJson(response.data);
      return loginRet;
    }
    return null;
  }
}
