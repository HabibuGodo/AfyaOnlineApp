import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';

class DownloadController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  // List<DownloadMovie>? downloadMovies;
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void onInit() {
    fetchData();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    super.onInit();
  }

  void fetchData() async {
    // downloadMovies = await DownloadMovie.getDummyList();
    await Future.delayed(Duration(seconds: 1));
    showLoading.value = false;
    uiLoading.value = false;
    update();
  }

  @override
  String getTag() {
    return "download_controller";
  }
}
