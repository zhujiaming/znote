import 'package:get/get.dart';
import 'package:znote/comm/date_util.dart';
import 'package:znote/comm/eventbus/eb.dart';
import 'package:znote/comm/eventbus/event_note_changed.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/db/db_helper.dart';
import 'package:znote/db/note_item.dart';

class WriteController extends GetxController {
  late NoteItem _noteItem;

  set noteContent(String newContent) {
    _noteItem.text = newContent;
    update();
    save();
  }

  String get noteContent {
    LogUtil.d("visit note contenttext");
    return _noteItem.text;
  }

  NoteItem get noteItem => _noteItem;

  @override
  void onInit() async {
    LogUtil.d("onInit run");
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
        LogUtil.d("noteitem is null ${_noteItem == null}");
      }
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
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
  }

  void save() {
    String content = _noteItem.text;
    int n = content.indexOf('\n');
    if (n <= 0) {
      _noteItem.title = _noteItem.text;
    } else {
      _noteItem.title = content.substring(
        0,
      );
    }
    DbHelper().noteDao.saveItem(_noteItem);
  }
}
