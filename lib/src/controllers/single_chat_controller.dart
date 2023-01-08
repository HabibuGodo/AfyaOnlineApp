import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutkit/src/models/chat.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutx/flutx.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../models/group_model.dart';
import '../models/message_model.dart';
import '../services/base_service.dart';

class SingleChatController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  var messageInput = ''.obs;
  late TextEditingController messageInputTE;

  late var groupId;
  late var groupName;

  // late Chat chat;
  var chat = <MessageModel>[].obs;
  late ThemeData theme;
  final senderId = authData.read('user_id');

  @override
  void onInit() {
    messageInputTE = TextEditingController();
    groupId = Get.arguments['groupId'];
    groupName = Get.arguments['groupName'];

    theme = AppTheme.communityTBTheme;
    getChatMessage(groupId);
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    messageInputTE.dispose();
  }

  // fetch dalali all items here
  Future<void> getChatMessage(var groupID) async {
    showLoading.value = true;
    uiLoading.value = true;
    try {
      // categories.value = Category.categoryList();

      Dio dio = Dio();

      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_messages"}));
      dio.interceptors.add(_dioCacheManager.interceptor);

      final response = await dio.get(
        '$baseURL/mygroups/$groupID/messages',
        options: cacheOptions,
      );

      if (response.statusCode == 200) {
        // decode response to observable list
        // log(response.data);
        var jsonResponse = response.data['data'];

        List<dynamic> dataEx = jsonResponse;

        chat.value = (dataEx).map((e) => MessageModel.fromMap(e)).toList().obs;

        EasyLoading.dismiss();
      } else {
        return;
      }
    } catch (e) {
      log("errrroo1 ${e.toString()}");
    } finally {
      showLoading.value = false;
      uiLoading.value = false;
    }
  }

  Stream<List<dynamic>> fetchsms(var groupID) async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));

      try {
        // categories.value = Category.categoryList();

        Dio dio = Dio();

        DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
        Options cacheOptions = buildCacheOptions(Duration(days: 30),
            forceRefresh: true,
            options: Options(extra: {"context": "all_messages"}));
        dio.interceptors.add(_dioCacheManager.interceptor);

        final response = await dio.get(
          '$baseURL/mygroups/$groupID/messages',
          options: cacheOptions,
        );

        if (response.statusCode == 200) {
          // decode response to observable list
          // log(response.data);
          var jsonResponse = response.data['data'];

          List<dynamic> dataEx = jsonResponse;

          chat.value =
              (dataEx).map((e) => MessageModel.fromMap(e)).toList().obs;

          var myList = List.from(chat);
          yield myList;
          // EasyLoading.dismiss();
        } else {
          return;
        }
      } catch (e) {
        log("errrroo1 ${e.toString()}");
      } finally {
        showLoading.value = false;
        uiLoading.value = false;
      }
    }
  }

  void sendMessage() async {
    EasyLoading.show(
      status: 'Sending...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final response =
          await http.post(Uri.parse('$baseURL/sendMessages'), body: {
        "group_id": groupId.toString(),
        "sender_id": senderId.toString(),
        "message": messageInput.value.toString(),
      }, headers: {
        "Accept": "application/json"
      });
      log(response.body);
      if (response.body.contains("success")) {
        // getChatMessage(groupId);
        messageInputTE.clear();
        messageInput.value = '';
        chat.refresh();
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      log("errrroo ${e.toString()}");
    } finally {
      EasyLoading.dismiss();
      showLoading.value = false;
      uiLoading.value = false;
    }
  }
}
