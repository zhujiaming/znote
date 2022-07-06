import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:znote/comm/date_util.dart';
import 'package:znote/comm/eventbus/eb.dart';
import 'package:znote/comm/eventbus/event_note_changed.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/db/db_helper.dart';
import 'package:znote/db/note_item.dart';

class WriteController extends GetxController {
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
  }

  @override
  void onReady() async {
    super.onReady();
    LogUtil.d("onReady run");
    if (Get.arguments == null) {
      initCreate();
    } else {
      String id = Get.arguments['id'];
      LogUtil.d("write note item id is:$id");
      var note = await DbHelper().noteDao.findNoteItemById(id);
      if (note == null) {
        initCreate();
      } else {
        _noteItem = note;
        initBrowse();
      }
    }
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

  void save() {
    if (_noteItem != null) {
      String content = _noteItem!.text;
      int n = content.indexOf('\n');
      if (n <= 0) {
        _noteItem!.title = _noteItem!.text;
      } else {
        _noteItem!.title = content.substring(
          0,
        );
      }
      DbHelper().noteDao.saveItem(_noteItem!);
    }
  }

  void initBrowse() {
    editWidgetController.text = _noteItem!.text;
    pagerWidgetController.jumpToPage(1);
    update();
  }
}
