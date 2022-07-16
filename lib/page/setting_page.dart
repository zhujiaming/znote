import 'package:flutter/material.dart';
import 'package:znote/comm/file_utils.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/main.dart';
import 'package:znote/res/r_colors.dart';
import 'package:znote/res/r_dimens.dart';
import 'package:process_run/shell.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("设置"),
        toolbarHeight: ResDim.appBarHeight,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      color: ResCol.bgColor,
      child: Column(
        children: [if (Global.isPC) _buildItem('打开缓存目录', _openCacheFolder)],
      ),
    );
  }

  _buildItem(String label, VoidCallback onPress) {
    return MaterialButton(
      height: 20,
      minWidth: double.infinity,
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      color: ResCol.bgItemColor,
      onPressed: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  void _openCacheFolder() {
    (FileUtils.getHomeDir()).then((res) {
      String path = res.path.replaceAll('/', '\\');
      Shell().runExecutableArguments('explorer', ['$path\\']);
    });
  }
}
