import 'dart:isolate';
import 'dart:ui';

import 'package:flutkit/src/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  late ThemeData theme;
  late TabController tabController;

  late final TickerProvider tickerProvider;

  // iniitialize counter
  @override
  void onInit() {
    super.onInit();
    // getbanners();
    EasyLoading.dismiss();
    theme = AppTheme.communityTBTheme;
    IsolateNameServer.registerPortWithName(
        Global.downloadPort.sendPort, 'downloader_send_port');

    Global.broadcastStream.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus downloadStatus = data[1];
      int progress = data[2];
      update();
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  handleTabSelection(var index) {
    currentIndex.value = index;
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }
}
