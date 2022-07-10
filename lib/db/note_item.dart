import 'package:floor/floor.dart';
import 'package:znote/db/consts.dart';
import 'package:znote/db/database.dart';

@Entity(tableName: DbConfig.TABLE_NAME_NOTE)
class NoteItem {
  @PrimaryKey()
  String id;
  String pid;
  int createTime;
  int updateTime;
  String text;
  String title;
  bool isTop;
  int state;
  int type;
  String extra;

  NoteItem(this.id,
      {this.pid = Consts.pidHome,
      this.createTime = 0,
      this.updateTime = 0,
      this.text = "",
      this.title = '',
      this.isTop = false,
      this.type = Consts.noteTypeFile,
      this.extra = '',
      this.state = Consts.noteStateAdd});

// NoteItem.from(
//   String id, {
//   int createTime = 0,
// }) : this(id, createTime: createTime);
}
