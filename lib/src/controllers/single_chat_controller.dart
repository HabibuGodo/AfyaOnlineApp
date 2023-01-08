import 'package:flutkit/src/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';

class SingleChatController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;

  late Chat chat;
  late ThemeData theme;

  @override
  void onInit() {
    fetchData();
    chat = Get.arguments['chat'];
    theme = AppTheme.communityTBTheme;

    super.onInit();
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 1));

    showLoading.value = false;
    uiLoading.value = false;
    // update();
  }
}
