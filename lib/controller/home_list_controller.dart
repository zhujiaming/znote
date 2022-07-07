import 'package:get/get.dart';
import 'package:znote/comm/eventbus/eb.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/controller/repo_binder.dart';
import 'package:znote/db/db_helper.dart';
import 'package:znote/db/note_item.dart';
import 'package:znote/main.dart';
import 'package:znote/repo/note_repo.dart';

class HomeListController extends RepoGetXController {
  List<NoteItem> noteDatas = [];
  List<String> selectNoteIds = [];

  bool isOptMode = false;

  @override
  void onInit() {
    super.onInit();
    bindRepo(NoteRepo());
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
    listenNoteChanged();
  }

  loadData({bool showState = true}) async {
    if (Global.isPC && showState) showLoading();
    noteDatas = await DbHelper().noteDao.findNoteItems();
    update();
    if (Global.isPC && showState) dismissLoading();
  }

  listenNoteChanged() {
    EventBusHelper.onNoteChanged((event) {
      LogUtil.d('home on note changed reload');
      loadData(showState: false);
    });
  }

  void addItem() {}

  void toggleOptMode() {
    isOptMode = !isOptMode;
    selectNoteIds.clear();
    update();
  }

  void toggleSelect(String id) {
    if (selectNoteIds.contains(id)) {
      selectNoteIds.remove(id);
    } else {
      selectNoteIds.add(id);
    }
    update();
  }

  bool isSelect(String id) {
    return selectNoteIds.contains(id);
  }

  void deleteNoteItems() {
    NoteRepo repo = getRepo(NoteRepo);
    repo.deleteNoteItems(selectNoteIds);
    selectNoteIds.clear();
    update();
  }
}
