import 'dart:async';

import 'package:floor/floor.dart';
import 'note_item.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

class DbConfig {
  static const int DB_VERSION = 1;
  static const String DB_NAME = "data.db";

  static const String TABLE_NAME_NOTE = "note";
}

@Database(version: DbConfig.DB_VERSION, entities: [NoteItem])
abstract class DataBase extends FloorDatabase {
  NoteDao get noteDao;
}

@dao
abstract class NoteDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> saveItem(NoteItem noteItem);

  @delete
  Future<void> deleteItem(NoteItem noteItem);

  @Query('DELETE FROM ${DbConfig.TABLE_NAME_NOTE} WHERE id IN (:noteIds)')
  Future<void> deleteItems(List<String> noteIds);

  @Query('SELECT * FROM ${DbConfig.TABLE_NAME_NOTE} WHERE id = :id')
  Future<NoteItem?> findNoteItemById(String id);

  @Query('SELECT * FROM ${DbConfig.TABLE_NAME_NOTE}  ORDER BY updateTime DESC')
  Future<List<NoteItem>> findNoteItems();
}
