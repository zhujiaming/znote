import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/comm/time_formatter.dart';
import 'package:znote/controller/home_list_controller.dart';
import 'package:znote/db/note_item.dart';
import 'package:znote/main.dart';
import 'package:znote/res/r_colors.dart';
import 'package:znote/res/r_dimens.dart';
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
    NoteItem noteItem = _homeListController.noteDatas[index];
    if (_homeListController.isOptMode) {
      _homeListController.toggleSelect(noteItem.id);
    } else {
      Get.toNamed(AppRouter.write, arguments: {'id': noteItem.id});
    }
  }

  void _onItemLongPress(BuildContext context, int index) {
    NoteItem noteItem = _homeListController.noteDatas[index];
    _homeListController.toggleOptMode();
    _homeListController.toggleSelect(noteItem.id);
  }

  Future<void> _onPullRefresh() async {
    await _homeListController.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeListController>(builder: (controller) {
      return Scaffold(
        appBar: _buildAppbar(context),
        body: _buildBody(context),
        floatingActionButton: Visibility(
          visible: !_homeListController.isOptMode,
          child: FloatingActionButton(
            onPressed: _onAddPress,
            tooltip: '新建',
            child: const Icon(Icons.add),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }

  _buildBody(BuildContext context) {
    return Container(
      color: ResCol.bgColor,
      child: Column(
        children: [
          // _buildHeader(context),
          Expanded(
              child: RefreshIndicator(
            onRefresh: _onPullRefresh,
            child: ListView.builder(
              itemBuilder: _buildItem,
              itemCount: _homeListController.noteDatas.length,
            ),
          )),
          if (_homeListController.isOptMode) _buildOptMenu(context)
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    NoteItem noteData = _homeListController.noteDatas[index];
    String title = noteData.title;

    if (title.length > 100) {
      title = title.substring(0, 100);
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Card(
          elevation: 4,
          shadowColor: Colors.white54,
          color: ResCol.bgItemColor,
          child: MaterialButton(
            onPressed: () => _onItemClick(context, index),
            onLongPress: () => _onItemLongPress(context, index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              width: double.infinity,
              height: 60,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        TimeFormatter.getHomeListFormatter(noteData.updateTime),
                        style: const TextStyle(
                            color: Color(0xffA2A2A2), fontSize: 13),
                      )
                    ],
                  ),
                  if (_homeListController.isOptMode)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(_homeListController.isSelect(noteData.id)
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank),
                    )
                ],
              ),
            ),
          ),
        ));
  }

  _buildTitleWidget() {
    const TextStyle appBarTextStyle =
        TextStyle(color: Colors.white, fontSize: 22);
    if (_homeListController.isOptMode) {
      // 选择模式
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              _homeListController.toggleOptMode();
            },
          ),
          Text(
            "已选择 ${_homeListController.selectNoteIds.length} 项",
            style: appBarTextStyle,
          )
        ],
      );
    } else {
      // 普通模式
      return MaterialButton(
        onPressed: _onAppBarCategoryPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "笔记本1",
              style: appBarTextStyle,
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 26,
            )
          ],
        ),
      );
    }
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      toolbarHeight: ResDim.appBarHeight,
      title: _buildTitleWidget(),
      actions: [
        IconButton(
            tooltip: "设置",
            onPressed: () => {},
            icon: const Icon(Icons.settings))
      ],
    );
  }

  _buildOptMenu(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MaterialButton(
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.vertical_align_top),
                SizedBox(
                  height: 2,
                ),
                Text(
                  '置顶',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          MaterialButton(
            onPressed: _onDeletePressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete),
                SizedBox(
                  height: 2,
                ),
                Text('删除', style: TextStyle(fontSize: 12))
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onDeletePressed() {
    showOkCancelAlertDialog(
            context: context,
            title: "提示",
            message: "将删除${_homeListController.selectNoteIds.length}项内容",
            okLabel: '好的',
            cancelLabel: '再想想')
        .then((okOrCancelResult) {
      if (okOrCancelResult == OkCancelResult.ok) {
        _homeListController.deleteNoteItems();
      }
    }).whenComplete(() {
      _homeListController.toggleOptMode();
    });
  }

  void _onAppBarCategoryPressed() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(
                      width: 5,
                    ),
                    Text("废纸篓")
                  ],
                ),
                onPressed: () {
                  Get.back();
                  showToast("前往废纸篓");
                },
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.create_new_folder_outlined),
                    SizedBox(
                      width: 5,
                    ),
                    Text("新建文件夹")
                  ],
                ),
                onPressed: () {
                  Get.back();
                  showToast("新建文件夹");
                },
              )
            ],
          );
        });
  }
}
