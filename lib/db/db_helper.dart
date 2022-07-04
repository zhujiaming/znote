import 'dart:io';

import 'package:floor/floor.dart';
import 'package:znote/comm/file_utils.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/db/database.dart';

class DbHelper {
  DbHelper._privateConstructor();

  static final DbHelper _inst = DbHelper._privateConstructor();

  factory DbHelper() {
    return _inst;
  }

  late DataBase dateBase;

  NoteDao get noteDao => dateBase.noteDao;

  init() async {
    File file = await FileUtils.getDbFile(DbConfig.DB_NAME);
    LogUtil.d("DB FILE PATH:${file.path}");
    try {
      dateBase = await $FloorDataBase
          .databaseBuilder(file.path)
          .addCallback(Callback(
              onCreate: (db, version) {
                LogUtil.d("db onCreate");
              },
              onOpen: (db) {
                LogUtil.d('db onOpen');
              },
              onUpgrade: (db, oldVersion, newVersion) {}))
          .build();
    } catch (e) {
      LogUtil.e("DB INIT ERROR:$e");
    }
  }
}
