import 'package:znote/comm/log_utils.dart';
import 'package:znote/controller/repo_binder.dart';

class HomePagePcController extends RepoGetXController {
  String _currentEditId = '';

  set editId(String value) {
    LogUtil.d('set home pc edit id:$value');
    _currentEditId = value;
    update();
  }

  String get editId => _currentEditId;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}
