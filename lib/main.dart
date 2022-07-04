import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/db/db_helper.dart';
import 'package:znote/res/r_strings.dart';
import 'package:znote/routers.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: ResStr.APP_NAME,
      // theme: ,
      getPages: AppRouter.pages,
      builder: EasyLoading.init(),
      initialRoute: AppRouter.home,
    );
  }
}

class Global {
  static bool get isPC =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  static bool get isDebug => !const bool.fromEnvironment("dart.vm.product");

  static init() async {
    LogUtil.init(isDebug: isDebug);
    LogUtil.d("====================== app init ======================");
    await DbHelper().init();
  }
}

showToast(String msg) {
  EasyLoading.showToast(msg);
}

showLoading() {
  EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.black);
}

dismissLoading() {
  EasyLoading.dismiss();
}
