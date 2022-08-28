import 'package:dio/dio.dart';
import 'package:znote/git/engine.dart';
import 'package:znote/git/entity/auth_ret.dart';
import 'package:znote/git/entity/http_resp.dart';
import 'package:znote/git/logic.dart';

///"message": "401 Unauthorized: Access token does not exist"

class Requests {
  static Future<String?> get accessToken async =>
      (await GitLogic.inst.getAuthInfo())?.accessToken;

  static Future<Map<String, dynamic>> get accessTokenMap async =>
      {'access_token': await accessToken};

  static Future<Map<String, dynamic>> buildParam(
      Map<String, dynamic> data) async {
    Map<String, dynamic> newData = {};
    newData.addAll((await accessTokenMap));
    newData.addAll(data);
    return newData;
  }

  static Future<AuthInfo?> auth() async {
    Resp resp = await Engine.post('https://gitee.com/oauth/token', {
      'grant_type': 'password',
      'username': 'ah_zjm@163.com',
      'password': 'zjm6253321',
      'client_id':
          '584f288684626a09db1098df1158845cd4de670fc2b013269fcc79cf411d9447',
      'client_secret':
          'ff4bd06b35b783d408258a17e5e198a7ccd058506cfd58c5597025e4dc6a3e78',
      'scope': 'projects gists',
    });

    // int statusCode = response.statusCode ?? -1;
    // if (statusCode == 200) {
    //   /// {
    //   /// "access_token":"85bec00aaaaf80d4cfe3c35dad4fc130"
    //   /// ,"token_type":"bearer"
    //   /// ,"expires_in":86400
    //   /// ,"refresh_token":"9cb37ddd9ad9f12f0ab89a89ed0983e7f056a0d5c969ea6603840527b7358725"
    //   /// ,"scope":"projects gists"
    //   /// ,"created_at":1661671164
    //   /// }
    //
    //   AuthInfo loginRet = AuthInfo.fromJson(response.data);
    //   return loginRet;
    // }

    if (resp.isSuccess) {
      return AuthInfo.fromJson(resp.data);
    }

    return null;
  }

  /// 获取目录Tree
  /// https://gitee.com/api/v5/swagger#/getV5ReposOwnerRepoGitTreesSha
  /// recursive 赋值为1递归获取目录
  static Future<Resp> trees({bool recursive = true}) async {
    String path = '/zhujiaming/test-note-repo/git/trees/master';
    return await Engine.get(
        path, ((await buildParam({'recursive': recursive ? 1 : 0}))));
  }

  ///获取文件Blob内容
  static Future<Resp> blobs(String sha) async {
    String path = '/zhujiaming/test-note-repo/git/blobs/$sha';
    return await Engine.get(path, await accessTokenMap);
  }
}
