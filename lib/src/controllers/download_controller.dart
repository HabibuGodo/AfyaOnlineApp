import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutkit/src/controllers/global.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/app_theme.dart';

class DownloadController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  // List<DownloadMovie>? downloadMovies;
  late ThemeData theme;
  late CustomTheme customTheme;

  var indexVarComp = false.obs;
  var indexVarComp2 = false.obs;

  @override
  void onInit() {
    fetchData();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    if (Platform.isAndroid) {
      Global.platform = TargetPlatform.android;
    } else {
      Global.platform = TargetPlatform.iOS;
    }

    // IsolateNameServer.registerPortWithName(
    //     Global.downloadPort.sendPort, 'downloader_send_port');

    // Global.broadcastStream.listen((dynamic data) {
    //   String id = data[0];
    //   DownloadTaskStatus downloadStatus = data[1];
    //   int progress = data[2];
    //   update();
    // });

    // FlutterDownloader.registerCallback(downloadCallback);

    //
    super.onInit();
  }

  void fetchData() async {
    // downloadMovies = await DownloadMovie.getDummyList();
    await Future.delayed(Duration(seconds: 1));
    showLoading.value = false;
    uiLoading.value = false;
  }

  // @override
  // void dispose() {
  //   IsolateNameServer.removePortNameMapping('downloader_send_port');
  //   super.dispose();
  // }

  // @pragma('vm:entry-point')
  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   final SendPort? send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send!.send([id, status, progress]);
  // }

  @override
  String getTag() {
    return "download_controller";
  }
}
