import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:znote/controller/home_page_pc_controller.dart';
import 'package:znote/page/home_page.dart';
import 'package:znote/page/write_page.dart';
import 'package:znote/res/r_colors.dart';

class HomePagePc extends StatefulWidget {
  const HomePagePc({Key? key}) : super(key: key);

  @override
  State<HomePagePc> createState() {
    return _HomePagePcState();
  }
}

class _HomePagePcState extends State<HomePagePc> {
  final HomePagePcController _homePagePcController =
  Get.put(HomePagePcController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      color: ResCol.bgColor,
      child: Row(
        children: [
          const SizedBox(
            width: 350,
            height: double.infinity,
            child: HomePage(),
          ),
          _buildWritePage()
        ],
      ),
    );
  }

  _buildWritePage() {
    return Expanded(
        child: GetBuilder<HomePagePcController>(builder: (controller) {
          if (_homePagePcController.editId.isEmpty) {
            return const Center(
              child: Text("点击左侧笔记列表打开内容"),
            );
          } else {
            return WritePage(
              editId: controller.editId,
            );
          }
        }));
  }
}
