import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

import '../../theme/app_theme.dart';

class DownloadController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  // List<DownloadMovie>? downloadMovies;
  late ThemeData theme;
  late CustomTheme customTheme;

  late var localPath = ''.obs;
  late var permissionReady = false.obs;
  late TargetPlatform? platform;
  var percentage = 0.obs;
  var indexVar1 = false.obs;
  var indexVar2 = false.obs;

  var indexVarComp = false.obs;
  var indexVarComp2 = false.obs;

  @override
  void onInit() {
    fetchData();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    super.onInit();
  }

  void fetchData() async {
    // downloadMovies = await DownloadMovie.getDummyList();
    await Future.delayed(Duration(seconds: 1));
    showLoading.value = false;
    uiLoading.value = false;
  }

  Future<bool> checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> prepareSaveDir() async {
    localPath.value = (await _findLocalPath())!;

    final savedDir = Directory(localPath.value);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      String dir = (await getExternalStorageDirectory())!.path;
      // String dir = "/sdcard/downloads";
      return dir;
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }

  Future<void> downloadNow(String urlPath, String filename, int index) async {
    await prepareSaveDir();
    try {
      final extension = p.extension(urlPath);
      await Dio()
          .download("$urlPath", localPath.value + "/" + "$filename.$extension",
              onReceiveProgress: (received, total) {
        percentage.value = ((received / total) * 100).floor();
      });

      if (percentage.value > 0 && percentage.value < 100) {
        if (index == 1) {
          indexVar1.value = true;
        } else {
          indexVar2.value = true;
        }
      } else if (percentage.value == 100) {
        downLoadData.write(
            filename, localPath.value + "/" + "$filename$extension");
        downLoadData.write("checkFilename", filename);
      }
    } catch (e) {
      print("Download Failed.\n\n" + e.toString());
    }
  }

 

  @override
  String getTag() {
    return "download_controller";
  }
}
