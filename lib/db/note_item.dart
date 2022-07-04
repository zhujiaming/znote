import 'package:floor/floor.dart';
import 'package:znote/db/database.dart';

@Entity(tableName: DbConfig.TABLE_NAME_NOTE)
class NoteItem {
  @PrimaryKey()
  String id;
  int createTime = 0; 
  int updateTime = 0;
  String text = "";
  String title = "";

  NoteItem(this.id,
      {this.createTime = 0,
      this.updateTime = 0,
      this.text = "",
      this.title = ''});

  NoteItem.from(
    String id, {
    int createTime = 0,
  }) : this(id, createTime: createTime);
}

