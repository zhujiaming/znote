import 'package:znote/controller/repo_binder.dart';
import 'package:znote/git/entity/git_file.dart';
import 'package:znote/git/logic.dart';
import 'package:znote/main.dart';

import '../entity/http_resp.dart';

class GitRepoController extends RepoGetXController {
  List<GitFile> mData = [];

  @override
  void onInit() {
    super.onInit();
  }

  loadData() async {
    loadingShow();
    Resp resp = await GitLogic.inst.trees();
    resp.showToastIf();
    if (resp.isSuccess) {
      mData = resp.data;
      showToast("更新${mData.length}条内容");
    }
    update();
    loadingDismiss();
  }

  void auth() async {
    loadingShow();
    bool ret = await GitLogic.inst.auth();
    showToast("登录${ret ? '成功' : '失败'}");
    loadingDismiss();
  }
}
