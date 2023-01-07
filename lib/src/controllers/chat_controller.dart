import 'package:flutkit/src/views/single_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../models/chat.dart';

class ChatController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  var chats = <Chat>[].obs;

  late ThemeData theme;

  @override
  void onInit() {
    fetchData();
    theme = AppTheme.reconSpotTheme;
    super.onInit();
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 1));

    chats.value = await Chat.getDummyList();

    showLoading.value = false;
    uiLoading.value = false;
    // update();
  }
}
