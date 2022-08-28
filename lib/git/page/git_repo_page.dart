import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:znote/git/entity/git_file.dart';
import 'package:znote/git/page/git_repo_controller.dart';

class GitRepoPage extends StatefulWidget {
  const GitRepoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GitRepoPageState();
  }
}

class GitRepoPageState extends State<GitRepoPage> {
  final GitRepoController _controller = Get.put(GitRepoController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GitRepoController>(builder: (ctl) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Git"),
          actions: [
            IconButton(
                tooltip: "登录",
                onPressed: () {
                  _controller.auth();
                },
                icon: const Icon(
                  Icons.man,
                )),
            IconButton(
                tooltip: "同步",
                onPressed: () {
                  _controller.loadData();
                },
                icon: const Icon(
                  Icons.sync,
                )),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemBuilder: (c, index) {
                  GitFile gitFile = _controller.mData[index];
                  return MaterialButton(
                    onPressed: () {},
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Row(
                        children: [Text(gitFile.path!)],
                      ),
                    ),
                  );
                },
                itemCount: _controller.mData.length,
              ))
            ],
          ),
        ),
      );
    });
  }

  static void showLoginDialog() {}
}
