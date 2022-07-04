import 'package:get/get.dart';
import 'package:znote/page/home_page.dart';
import 'package:znote/page/write_page.dart';

/// 路由
class AppRouter {
  static const String home = "/home";
  static const String write = "/write";

  static final List<GetPage> pages = [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: write, page: () => WritePage()),
  ];
}
