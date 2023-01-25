import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutkit/src/controllers/chats/global.dart';
import 'package:flutkit/src/models/single_message_model.dart';
import 'package:flutkit/src/models/user_model.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';
import '../../models/message_model.dart';
import '../../services/LocalNotificationReceiverService.dart';
import '../../services/base_service.dart';

class AllInsideChatController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  var messageInput = ''.obs;
  late TextEditingController messageInputTE;

  late var groupId;
  late var receiverId;
  late var groupName;
  late var receiverName;
  late var checkRoute;
  late var firebaseToken;

  // late Chat chat;
  late ThemeData theme;
  final senderId = authData.read('user_id');

  @override
  void onInit() {
    messageInputTE = TextEditingController();
    theme = AppTheme.communityTBTheme;

    checkRoute = Get.arguments['checkRoute'];
    if (checkRoute == 'single') {
      receiverId = Get.arguments['otherUserId'];
      receiverName = Get.arguments['receiverName'];
      firebaseToken = Get.arguments['firebaseToken'];
      filterSingleChatMessage(receiverId);
    } else {
      groupId = Get.arguments['groupId'];
      groupName = Get.arguments['groupName'];
      filterGroupChatMessage(groupId);
    }

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    messageInputTE.dispose();
  }

//filter all single chat messages
  void filterSingleChatMessage(var receiverId) {
    updateMessageRead();
    Global.singleChat.value = Global.singleChatTem
        .where((element) =>
            element.receiverId!.isEqual(receiverId) ||
            element.senderId!.isEqual(receiverId))
        .toList()
        .obs;
  }

  //filter all single chat messages
  void filterGroupChatMessage(var groupId) {
    // updateMessageRead();
    Global.groupChat.value = Global.groupChatTemp
        .where((element) => element.groupId!.isEqual(groupId))
        .toList()
        .obs;
  }

//=========================send group message
  void sendMessage() async {
    try {
      final response =
          await http.post(Uri.parse('$baseURL/sendMessages'), body: {
        "group_id": groupId.toString(),
        "sender_id": senderId.toString(),
        "message": messageInput.value.toString(),
      }, headers: {
        "Accept": "application/json"
      });

      if (response.body.contains("success")) {
        // getChatMessage(groupId);
        messageInputTE.clear();
        messageInput.value = '';
        Global.groupChat.refresh();
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

//==============================SINGLE CHAT

  Future<void> checkInternetThenSend() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      EasyLoading.showError('No internet connection.');
      // checkDataConnection.value = "No internet connection.";
    } else {
      bool result = await DataConnectionChecker().hasConnection;
      if (result == true) {
        await sendSingleMessage();
      } else {
        EasyLoading.showError('No internet connection.');

        // checkDataConnection.value = "No internet connection.";
      }
    }
  }

  Future sendSingleMessage() async {
    var msg = messageInput.value.toString();
    messageInputTE.clear();
    messageInput.value = '';
    Global.singleChat.refresh();
    try {
      final response =
          await http.post(Uri.parse('$baseURL/sendMessageSingle'), body: {
        "receiver_id": receiverId.toString(),
        "sender_id": senderId.toString(),
        "message": msg,
      }, headers: {
        "Accept": "application/json"
      });

      if (response.body.contains("success")) {
        var payloadData = {
          'title': 'New Message',
          'body': messageInput.value.toString(),
          'senderId': senderId.toString(),
          'senderName': authData.read('name').toString(),
          'senderProfile': authData.read('profile_image'),
          'senderFirebaseToken': authData.read('firebaseToken'),
          'checkRoute': 'single',
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'sound': 'default',
          'vibrate': true,
          'enableLights': true,
        };

//send notification=============================================================
        await LocalNotificationService.send_push_notification(firebaseToken,
            'New Message', payloadData, messageInput.value.toString());
//==============================================================================

        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      log("errrr ${e.toString()}");
    } finally {
      EasyLoading.dismiss();
      showLoading.value = false;
      uiLoading.value = false;
    }
  }

  //update message read status
  Future updateMessageRead() async {
    try {
      final response =
          await http.post(Uri.parse(baseURL + '/updateMessageRead'), body: {
        //for here i will check those message where receiver is me so here me is sender that is why i
        //put senderId in receiverId that i will check if my id is in receiver column inndatabase
        'receiverId': senderId.toString(),
        'senderId': receiverId.toString(),
      }, headers: {
        'Accept': 'application/json'
      });
      if (response.statusCode == 200) {
        // print("${response.body}");
      } else {
        log("errrroo ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }
}
