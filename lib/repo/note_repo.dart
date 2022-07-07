import 'package:znote/comm/eventbus/eb.dart';
import 'package:znote/comm/eventbus/event_note_changed.dart';
import 'package:znote/db/database.dart';
import 'package:znote/db/db_helper.dart';
import 'package:znote/db/note_item.dart';
import 'package:znote/repo/base_repo.dart';

class NoteRepo extends BaseRepo {
  NoteDao get noteDao => DbHelper().noteDao;

  Future<void> deleteNoteItems(List<String> noteIds) async {
    await DbHelper().noteDao.deleteItems(noteIds);
    EventBusHelper.fire(EventNoteChanged());
  }

  Future<void> saveItem(NoteItem noteItem, {bool notify = false}) async {
    noteDao.saveItem(noteItem);
    if (notify) EventBusHelper.fire(EventNoteChanged());
  }

  @override
  void onClose() {}
}
