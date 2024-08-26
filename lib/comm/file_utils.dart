import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  static const String appHomeName = "znote";
  ///获取应用存储主目录
  ///C:\Users\zhujm\Documents/znote/data.db
  static Future<Directory> getHomeDir() async {
    var dir;
    if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else if (Platform.isWindows) {
      dir = await getApplicationDocumentsDirectory();
    } else if(Platform.isMacOS){
      dir = await getApplicationDocumentsDirectory();
    }else {
      dir = await getExternalStorageDirectory();
    }
    var homePath = '${dir!.path}/$appHomeName';
    var homeDir = Directory(homePath);
    if (!homeDir.existsSync()) {
      homeDir.createSync();
    }
    return homeDir;
  }

  static Future<File> getDbFile(String dbFileName) async {
    var homeDir = await getHomeDir();
    return File('${homeDir.path}/$dbFileName');
  }
}
