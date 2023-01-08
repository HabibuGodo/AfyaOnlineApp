import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutkit/src/models/group_model.dart';
import 'package:flutkit/src/views/single_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../models/chat.dart';
import '../services/base_service.dart';
import '../services/local_storage.dart';

class ChatController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  var chats = <Chat>[].obs;

  late ThemeData theme;
  var groups = <GroupModel>[].obs;
  late var userId;

  @override
  void onInit() {
    fetchData();
    theme = AppTheme.communityTBTheme;
    userId = authData.read("user_id");
    getGroups();
    super.onInit();
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 1));

    chats.value = await Chat.getDummyList();

    showLoading.value = false;
    uiLoading.value = false;
    update();
  }

  // fetch dalali all items here
  Future<void> getGroups() async {
    showLoading.value = true;
    uiLoading.value = true;
    try {
      // categories.value = Category.categoryList();

      Dio dio = Dio();

      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_groups"}));
      dio.interceptors.add(_dioCacheManager.interceptor);

      final response = await dio.get(
        '$baseURL/mygroups/$userId',
        options: cacheOptions,
      );

      if (response.statusCode == 200) {
        // decode response to observable list
        // log(response.data);
        var jsonResponse = response.data['data'];

        List<dynamic> dataEx = jsonResponse;

        groups.value = (dataEx).map((e) => GroupModel.fromMap(e)).toList().obs;
        EasyLoading.dismiss();
      } else {
        return;
      }

      // }
    } catch (e) {
      log("errrroo ${e.toString()}");
    } finally {
      showLoading.value = false;
      uiLoading.value = false;
    }
  }
}
