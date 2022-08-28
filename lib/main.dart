import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/db/db_helper.dart';
import 'package:znote/res/r_colors.dart';
import 'package:znote/res/r_strings.dart';
import 'package:znote/routers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Global.isPC) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1000, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();

    return GetMaterialApp(
        title: ResStr.APP_NAME,
        // theme: ,
        getPages: AppRouter.pages,
        builder: EasyLoading.init(),
        initialRoute: Global.isPC ? AppRouter.home_pc : AppRouter.home,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // This is required
        ],
        theme: ThemeData(
            colorScheme: theme.colorScheme.copyWith(
          primary: ResCol.primaryColor,
          secondary: ResCol.secondaryColor,
        )));
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

loadingShow() {
  showLoading();
}

dismissLoading() {
  EasyLoading.dismiss();
}

loadingDismiss() {
  dismissLoading();
}
