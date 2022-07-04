import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:znote/comm/eventbus/eb.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/db/db_helper.dart';
import 'package:znote/db/note_item.dart';
import 'package:znote/main.dart';

class HomeListController extends GetxController {
  List<NoteItem> noteDatas = [];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
    listenNoteChanged();
  }

  loadData({bool showState = true}) async {
    if (Global.isPC && showState) showLoading();
    noteDatas = await DbHelper().noteDao.findNoteItems();
    update();
    if (Global.isPC && showState) dismissLoading();
  }

  listenNoteChanged() {
    EventBusHelper.onNoteChanged((event) {
      LogUtil.d('home on note changed reload');
      loadData(showState: false);
    });
  }

  void addItem() {}
}
