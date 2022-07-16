import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:znote/comm/flustars/date_util.dart';
import 'package:znote/comm/eventbus/eb.dart';
import 'package:znote/comm/eventbus/event_note_changed.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/controller/repo_binder.dart';
import 'package:znote/db/db_helper.dart';
import 'package:znote/db/note_item.dart';
import 'package:znote/repo/note_repo.dart';

class WriteController extends RepoGetXController {
  FocusNode editFocusNode = FocusNode();
  TextEditingController editWidgetController = TextEditingController();
  PageController pagerWidgetController = PageController();

  NoteItem? _noteItem;

  set noteContent(String newContent) {
    if (_noteItem != null) {
      _noteItem!.text = newContent;
      update();
      save();
    }
  }

  String get noteContent {
    if (_noteItem == null) return "";
    return _noteItem!.text;
  }

  // NoteItem get noteItem => _noteItem;

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
    super.onClose();
    EventBusHelper.fire(EventNoteChanged());
  }

  void initCreate() {
    LogUtil.d("write note init create");
    int currentTime = DateUtil.getNowDateMs();
    _noteItem = NoteItem('$currentTime',
        createTime: currentTime, updateTime: currentTime);
    editFocusNode.requestFocus();
  }

  void save() async {
    if (_noteItem != null) {
      String content = _noteItem!.text;
      int n = content.indexOf('\n');

      if (n <= 0) {
        _noteItem!.title = _noteItem!.text;
      } else {
        String title = content
            .substring(0, n)
            .replaceAll("#", '')
            .replaceAll('>', '')
            .replaceAll('`', '')
            .trim();
        if (title.length > 100) {
          title = title.substring(0, 100);
        }
        _noteItem!.title = title;
      }
      ((await getRepo(NoteRepo) as NoteRepo))
          .saveItem(_noteItem!, notify: true);
    }
  }

  void initBrowse() {
    editWidgetController.text = _noteItem!.text;
    pagerWidgetController.jumpToPage(1);
    update();
  }

  void initData({String? id}) async {
    if (Get.arguments == null && id == null) {
      initCreate();
    } else {
      String tmpId = id ?? Get.arguments['id'];
      LogUtil.d("write note item id is:$tmpId");
      var note = await (await getRepo(NoteRepo) as NoteRepo)
          .noteDao
          .findNoteItemById(tmpId);
      if (note == null) {
        initCreate();
      } else {
        _noteItem = note;
        initBrowse();
      }
    }
  }
}
