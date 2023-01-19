import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/message_model.dart';
import '../../models/single_message_model.dart';
import '../../services/base_service.dart';

class Global {
  static var singleChat = <SingleMessageModel>[].obs;
  static var singleChatTem = <SingleMessageModel>[].obs;
  static var groupChat = <MessageModel>[].obs;
  static var groupChatTemp = <MessageModel>[].obs;
  static var totalUnreadAllConvo = 0.obs;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Stream<List<dynamic>> fetchSinglesms(var myId, var receiverId) async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));

      try {
        // categories.value = Category.categoryList();

        Dio dio = Dio();

        DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
        Options cacheOptions = buildCacheOptions(Duration(days: 30),
            forceRefresh: true,
            options: Options(extra: {"context": "all_messagesSingle"}));
        dio.interceptors.add(_dioCacheManager.interceptor);

        final response = await dio.get(
          '$baseURL/messagesInbox/$myId/$receiverId',
          options: cacheOptions,
        );

        if (response.statusCode == 200) {
          // decode response to observable list
          // log(response.data);
          var jsonResponse = response.data['data'];

          List<dynamic> dataEx = jsonResponse;

          Global.singleChat.value =
              (dataEx).map((e) => SingleMessageModel.fromMap(e)).toList().obs;

          var myList = List.from(Global.singleChat);

          yield myList;
          // EasyLoading.dismiss();
        } else {
          return;
        }
      } catch (e) {
        log("errrr ${e.toString()}");
      }
    }
  }

  static Stream<List<dynamic>> fetchsms(var groupID) async* {
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

          groupChat.value =
              (dataEx).map((e) => MessageModel.fromMap(e)).toList().obs;

          var myList = List.from(groupChat);
          yield myList;
          // EasyLoading.dismiss();
        } else {
          return;
        }
      } catch (e) {
        log("err1 ${e.toString()}");
      }
    }
  }

  static void verifyUser(String emailAddress, String password) async {
    try {
      firebaseAuth.signOut();
      await firebaseAuth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
      log("userId");
      saveFirebaseToken();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await firebaseAuth.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        log("1userId");
        saveFirebaseToken();
      }
    }
  }

  //save firebase token
  static Future saveFirebaseToken() async {
    var userId = authData.read("user_id");

    await FirebaseMessaging.instance.getToken().then((token) async {
      final tokenStr = token.toString();

      if (tokenStr.isNotEmpty) {
        // firebaseToken
        authData.write('firebaseToken', tokenStr);
        //save token
        try {
          var response =
              await http.post(Uri.parse('$baseURL/updateFirebaseToken'), body: {
            'userId': userId.toString(),
            'firebaseToken': tokenStr,
          }, headers: {
            'Accept': 'application/json'
          });
          log(response.body);
          if (response.statusCode == 200) {
            var data = json.decode(response.body);
            print(data);
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
