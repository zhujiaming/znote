import 'package:znote/controller/repo_binder.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quill;

import '../comm/log_utils.dart';
import '../repo/note_repo.dart';

class EditorPageController extends RepoGetXController{

  final Quill.QuillController quillController = Quill.QuillController.basic();


  @override
  void onInit() async {
    LogUtil.d("onInit run");
    super.onInit();
    bindRepo(NoteRepo());
  }

  @override
  void onReady() async {
    super.onReady();
    LogUtil.d("onReady run");
    initData();
  }

  @override
  void onClose() {
    _controller.dispose();
    super.onClose();
  }

  void initData() {}

}