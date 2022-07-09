import 'package:get/get.dart';
import 'package:znote/comm/eventbus/eb.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/controller/repo_binder.dart';
import 'package:znote/db/consts.dart';
import 'package:znote/db/db_helper.dart';
import 'package:znote/db/note_item.dart';
import 'package:znote/main.dart';
import 'package:znote/repo/note_repo.dart';

class HomeListController extends RepoGetXController {
  List<NoteItem> noteDatas = [];
  List<String> selectNoteIds = [];

  bool isOptMode = false;
  bool currentTopIntent = false;
  List<String> currentPidStack = [Consts.pidHome];

  String get currentPid => currentPidStack[currentPidStack.length - 1];

  bool get isRecyclerListMode => currentPid == Consts.pidRecycle;

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

  toRecyclerMode() {
    currentPidStack.add(Consts.pidRecycle);
    loadData(showState: false);
    update();
  }

  exitRecyclerMode() {
    if (currentPidStack[currentPidStack.length - 1] == Consts.pidRecycle) {
      currentPidStack.removeLast();
    }
    loadData(showState: false);
    update();
  }

  loadData({bool showState = true}) async {
    if (Global.isPC && showState) showLoading();
    NoteRepo noteRepo = getRepo(NoteRepo);

    if (currentPid == Consts.pidRecycle) {
      noteDatas = await noteRepo.findDelNoteItems();
    } else {
      noteDatas = await noteRepo.findNoteItemsForShow(currentPid);
    }

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
    currentTopIntent = getTopIntent();
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

  ///获取当前置顶意图，true 想要置顶，false 想要取消置顶
  bool getTopIntent() {
    List<NoteItem> dataArray = noteDatas
        .where(
            (element) => (selectNoteIds.contains(element.id)) && element.isTop)
        .toList();
    bool noTop = dataArray.isEmpty;
    return noTop;
  }

  toggleTop() async {
    bool topIntent = getTopIntent();
    NoteRepo repo = getRepo(NoteRepo);
    await repo.setTop(selectNoteIds, isTop: topIntent, notify: true);
  }
}
