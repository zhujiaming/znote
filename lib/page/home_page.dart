import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:znote/comm/time_formatter.dart';
import 'package:znote/controller/home_list_controller.dart';
import 'package:znote/db/note_item.dart';
import 'package:znote/main.dart';
import 'package:znote/res/r_colors.dart';
import 'package:znote/res/r_dimens.dart';
import 'package:znote/res/r_strings.dart';
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
    if (_homeListController.isRecyclerListMode &&
        !_homeListController.isOptMode) {
      _onItemLongPress(context, index);
    } else if (_homeListController.isOptMode) {
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
          visible: shouldShowFloatActionButton(),
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
            child: _buildListView(context),
          )),
          if (_homeListController.isOptMode) _buildOptMenu(context)
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    int dataCount = _homeListController.noteDatas.length;
    if (dataCount == 0) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🍉\n没有内容',
              textAlign: TextAlign.center,
              style: TextStyle(color: ResCol.fontTipColor, fontSize: 16),
            )
          ],
        ),
      );
    } else
      return ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 80),
        itemBuilder: _buildItem,
        itemCount: _homeListController.noteDatas.length,
      );
  }

  Widget _buildItem(BuildContext context, int index) {
    NoteItem noteData = _homeListController.noteDatas[index];
    String title = noteData.title;

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
                    ),
                  if (noteData.isTop)
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        '📌',
                        style: TextStyle(fontSize: 16),
                      ),
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
    if (!isNormalListMode()) {
      // 选择模式
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _exitCurrentMode,
          ),
          Text(
            _getModeTitle(),
            style: appBarTextStyle,
          )
        ],
      );
    } else {
      // 普通模式
      return MaterialButton(
        height: ResDim.appBarHeight,
        onPressed: _onAppBarCategoryPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "笔记",
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
        children: _getOptMenuItems(),
      ),
    );
  }

  List<Widget> _getOptMenuItems() {
    if (_homeListController.isRecyclerListMode) {
      return [
        MaterialButton(
          onPressed: () {
            showToast("已恢复${_homeListController.selectNoteIds.length}项内容");
            _homeListController.revertNoteItems();
            // _homeListController.toggleOptMode();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.takeout_dining),
              const SizedBox(
                height: 2,
              ),
              Text(
                '恢复',
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
        SizedBox(
          width: 5,
        ),
        MaterialButton(
          onPressed: _onDeleteRealPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_forever_rounded),
              SizedBox(
                height: 2,
              ),
              Text('彻底删除', style: TextStyle(fontSize: 12))
            ],
          ),
        )
      ];
    } else
      return [
        MaterialButton(
          onPressed: () {
            _homeListController.toggleTop();
            _homeListController.toggleOptMode();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.vertical_align_top),
              const SizedBox(
                height: 2,
              ),
              Text(
                _homeListController.currentTopIntent ? '置顶' : '取消置顶',
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
      ];
  }

  void _onDeletePressed() {
    _homeListController.deleteNoteItems().whenComplete(() {
      _homeListController.toggleOptMode();
    });
  }

  void _onDeleteRealPressed() {
    showOkCancelAlertDialog(
            context: context,
            title: "提示",
            message: "将彻底删除${_homeListController.selectNoteIds.length}项内容",
            okLabel: '好的',
            cancelLabel: '再想想')
        .then((okOrCancelResult) {
      if (okOrCancelResult == OkCancelResult.ok) {
        _homeListController.deleteNoteItemsReal();
      }
    }).whenComplete(() {});
  }

  void _onAppBarCategoryPressed() {
    Function ItemWeiget = (IconData iconData, String lable) {
      return SizedBox(
        width: double.infinity,
        height: 45,
        child: Row(
          children: [
            Icon(iconData),
            SizedBox(
              width: 5,
            ),
            Text(lable)
          ],
        ),
      );
    };

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: ItemWeiget(Icons.delete_outline, ResStr.recycler),
                onPressed: () {
                  Get.back();
                  _homeListController.toggleOptMode();
                  _homeListController.toRecyclerMode();
                },
              ),
              SimpleDialogOption(
                child: ItemWeiget(Icons.create_new_folder_outlined, "新建文件夹"),
                onPressed: () {
                  Get.back();
                  showToast("新建文件夹");
                },
              )
            ],
          );
        });
  }

  bool shouldShowFloatActionButton() {
    return !_homeListController.isOptMode &&
        !_homeListController.isRecyclerListMode;
  }

  bool isNormalListMode() {
    return !_homeListController.isOptMode &&
        !_homeListController.isRecyclerListMode;
  }

  void _exitCurrentMode() {
    if (_homeListController.isRecyclerListMode) {
      if (_homeListController.isOptMode) _homeListController.toggleOptMode();
      _homeListController.exitRecyclerMode();
    } else if (_homeListController.isOptMode) {
      _homeListController.toggleOptMode();
    }
  }

  String _getModeTitle() {
    int selCount = _homeListController.selectNoteIds.length;
    String selectStr = "已选择 $selCount 项";
    if (selCount == 0) {
      selectStr = '';
    }
    return _homeListController.isRecyclerListMode
        ? '${ResStr.recycler} $selectStr'
        : _homeListController.isOptMode
            ? selectStr
            : "";
  }
}
