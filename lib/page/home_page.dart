import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:znote/controller/home_list_controller.dart';
import 'package:znote/main.dart';
import 'package:znote/res/r_colors.dart';
import 'package:znote/routers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final HomeListController _homeListController = Get.put(HomeListController());

  void _onAddPress() {
    Get.toNamed(AppRouter.write);
  }

  void _onItemClick(BuildContext context, int index) {
    Get.toNamed(AppRouter.write,
        arguments: {'id': _homeListController.noteDatas[index].id});
  }

  void _onItemLongPress(BuildContext context, int index) {

  }

  Future<void> _onPullRefresh() async {
    await _homeListController.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: Column(
        children: [
          Expanded(
              child: RefreshIndicator(
            onRefresh: _onPullRefresh,
            child: GetBuilder<HomeListController>(
              builder: (controller) {
                return ListView.builder(
                  itemBuilder: _buildItem,
                  itemCount: _homeListController.noteDatas.length,
                );
              },
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddPress,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    String title = _homeListController.noteDatas[index].text;

    if (title.length > 10) {
      title = title.substring(0, 10);
    }

    return MaterialButton(
      onPressed: () => _onItemClick(context, index),
      onLongPress: () => _onItemLongPress(context, index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        width: double.infinity,
        height: 60,
        color: ResCol.bgItem,
        child: Row(
          children: [Text(title)],
        ),
      ),
    );
  }

  _buildAppbar(BuildContext context) {
    return null;
    return AppBar(
      title: const Text("Home"),
      actions: [IconButton(onPressed: () => {}, icon: const Icon(Icons.more))],
    );
  }
}
