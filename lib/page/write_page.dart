import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/controller/write_controller.dart';

class WritePage extends StatelessWidget {
  final WriteController _writeController = Get.put(WriteController());
  TextEditingController _mdController = TextEditingController();

  WritePage({Key? key}) : super(key: key);

  void _onPageChanged(int pageIndex) {}

  void _changePage(int index) {
    _writeController.pagerWidgetController.jumpToPage(index);
    // setState(() {});
  }

  void _onTextChanged(String value) {
    LogUtil.d("input:$value");
    // setState(() {
    // mdData = value.replaceAll('\n','');
    _writeController.noteContent = value;
    // });
    // _writeController.save();
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 30,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _changePage(0);
                      },
                    )),
                SizedBox(
                    width: 30,
                    child: IconButton(
                      icon: Icon(Icons.preview),
                      onPressed: () {
                        _changePage(1);
                      },
                    )),
                SizedBox(
                    width: 30,
                    child: IconButton(
                      icon: Icon(Icons.vertical_split),
                      onPressed: () {
                        _changePage(2);
                      },
                    )),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<WriteController>(
        builder: (controller) {
          return _buildBody();
        },
      ),
    );
  }

  _buildBody() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: PageView(
        scrollDirection: Axis.horizontal,
        reverse: false,
        controller: _writeController.pagerWidgetController,
        onPageChanged: _onPageChanged,
        //每次滑动是否强制切换整个页面，如果为false，则会根据实际的滑动距离显示页面
        pageSnapping: true,
        children: [
          _buildEditWidget(),
          _buildPreviewWidget(),
          _buildSplitWidget(),
        ],
      ),
    );
  }

  _buildEditWidget() {
    LogUtil.d("build edit widget");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Column(
        children: [
          Expanded(
            child: TextField(
                maxLines: null,
                focusNode: _writeController.editFocusNode,
                controller: _writeController.editWidgetController,
                keyboardType: TextInputType.multiline,
                onChanged: _onTextChanged,
                decoration: const InputDecoration.collapsed(
                    hintText: "开始书写...",
                )),
          )
        ],
      ),
    );
  }

  _buildPreviewWidget() {
    LogUtil.d("build preview widget");
    return SizedBox.expand(
      child: Markdown(
        selectable: true,
        data: _writeController.noteContent,
      ),
    );
  }

  _buildSplitWidget() {
    LogUtil.d("build split widget");
    return SizedBox.expand(
        child: Row(
      children: [
        Expanded(
          child: _buildEditWidget(),
          flex: 1,
        ),
        Container(
          width: 1,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          color: Colors.blueGrey,
        ),
        Expanded(
          child: _buildPreviewWidget(),
          flex: 1,
        ),
      ],
    ));
  }
}
