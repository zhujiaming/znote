import 'package:get/get.dart';
import 'package:znote/page/home_page.dart';
import 'package:znote/page/home_page_pc.dart';
import 'package:znote/page/setting_page.dart';
import 'package:znote/page/write_page.dart';

/// 路由
class AppRouter {
  static const String home = "/home";
  static const String home_pc = "/home_pc";
  static const String write = "/write";
  static const String setting = "/setting";

  static final List<GetPage> pages = [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: home_pc, page: () => const HomePagePc()),
    GetPage(name: write, page: () => WritePage()),
    GetPage(name: setting, page: () => const SettingPage()),
  ];
}
