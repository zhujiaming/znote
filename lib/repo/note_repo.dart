import 'package:znote/comm/eventbus/eb.dart';
import 'package:znote/comm/eventbus/event_note_changed.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/db/consts.dart';
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

  Future<void> deleteNoteItemsReal(List<String> noteIds) async {
    await DbHelper().noteDao.deleteItemsReal(noteIds);
    EventBusHelper.fire(EventNoteChanged());
  }

  revertNoteItems(List<String> selectNoteIds) async{
    await DbHelper().noteDao.revertNoteItems(selectNoteIds);
    EventBusHelper.fire(EventNoteChanged());
  }

  Future<void> saveItem(NoteItem noteItem, {bool notify = true}) async {
    await noteDao.saveItem(noteItem);
    if (notify) EventBusHelper.fire(EventNoteChanged());
  }

  /// 置顶Or取消置顶
  Future<void> setTop(List<String> noteIds,
      {bool isTop = false, bool notify = true}) async {
    LogUtil.d('set top:$isTop , noteIds$noteIds');
    await noteDao.setTop(noteIds, isTop ? 1 : 0);
    if (notify) EventBusHelper.fire(EventNoteChanged());
  }

  Future<List<NoteItem>> findNoteItemsForShow(String pid) async {
    return await noteDao.findNoteItems(pid, [
      Consts.noteStateAdd,
      Consts.noteStateUpdate,
      Consts.noteStateNormal,
    ]);
  }

  Future<List<NoteItem>> findDelNoteItems() async {
    return await noteDao.findDelNoteItems();
  }


}
