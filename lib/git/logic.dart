import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:znote/comm/flustars/date_util.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/git/entity/auth_ret.dart';
import 'package:znote/git/entity/git_file.dart';
import 'package:znote/git/requests.dart';
import 'package:znote/git/store.dart';

import 'entity/http_resp.dart';

///  GitLogic <-> UIController <-> UI
///     | /\
///    \/ |
/// Repository ( store、request)

class GitLogic {
  static int lastLogin = 0;

  GitLogic._();

  static GitLogic get inst => _get();
  static GitLogic? _instance;

  static GitLogic _get() {
    return _instance ??= GitLogic._();
  }

  final Store store = Store();

  ///
  /// 远端认证
  ///
  Future<bool> auth() async {
    // AuthInfo? loginRet = await store.getAuthInfo();

    if (lastLogin != 0 &&
        lastLogin > DateUtil.getNowDateMs() - 10 * 60 * 1000) {
      LogUtil.e('距上次登录成功时间小于10分钟');
      return false;
    }

    AuthInfo? loginRet = await Requests.auth();
    if (loginRet == null) {
      if (loginRet != null) {
        store.saveAuthInfo(loginRet);
      }
    }
    if (loginRet != null) {
      lastLogin = DateUtil.getNowDateMs();
    }

    return loginRet != null;
  }

  Future<AuthInfo?> getAuthInfo() async {
    return await store.getAuthInfo();
  }

  ///
  /// 获取目录Tree
  ///   /// {
  ///     "sha": "master",
  ///     "url": "https://gitee.com/api/v5/repos/zhujiaming/test-note-repo/git/trees/master",
  ///     "tree": [
  ///         {
  ///             "path": "2022",
  ///             "mode": "40000",
  ///             "type": "tree",
  ///             "sha": "966a31062c7371d900423c5694bd2034a85d1761",
  ///             "size": 0,
  ///             "url": "https://gitee.com/api/v5/repos/zhujiaming/test-note-repo/git/trees/966a31062c7371d900423c5694bd2034a85d1761"
  ///         },
  ///         {
  ///             "path": "README.en.md",
  ///             "mode": "100644",
  ///             "type": "blob",
  ///             "sha": "6221bcda0602cd093c059c7a8c9e45823922cea6",
  ///             "size": 956,
  ///             "url": "https://gitee.com/api/v5/repos/zhujiaming/test-note-repo/git/blobs/6221bcda0602cd093c059c7a8c9e45823922cea6"
  ///         },
  ///         {
  ///             "path": "README.md",
  ///             "mode": "100644",
  ///             "type": "blob",
  ///             "sha": "269db654ed1f4652a2b7ab53a6a2f8238263f53c",
  ///             "size": 1317,
  ///             "url": "https://gitee.com/api/v5/repos/zhujiaming/test-note-repo/git/blobs/269db654ed1f4652a2b7ab53a6a2f8238263f53c"
  ///         }
  ///     ],
  ///     "truncated": false
  /// }
  ///
  ///
  Future<Resp> trees() async {
    Resp resp = await Requests.trees();
    if (resp.isSuccess) {
      List<GitFile> listData =
          (resp.data['tree'] as List).map((e) => GitFile.fromJson(e)).toList();
      resp.data = listData;
    }
    return resp;
  }
}
