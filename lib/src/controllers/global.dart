import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../models/message_model.dart';
import '../models/single_message_model.dart';
import '../services/base_service.dart';

class Global {
  static var singleChat = <SingleMessageModel>[].obs;
  static var singleChatTem = <SingleMessageModel>[].obs;
  static var groupChat = <MessageModel>[].obs;
  static var groupChatTemp = <MessageModel>[].obs;
  static var totalUnreadAllConvo = 0.obs;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static var groupTokensList = ''.obs;
  static var localPath = ''.obs;
  static var permissionReady = false.obs;
  static TargetPlatform? platform;
  static var percentage = 0.obs;
  static var indexVar1 = false.obs;
  static var indexVar2 = false.obs;

  static var downloadPort = ReceivePort();
  static var broadcastStream = downloadPort.asBroadcastStream();

  static var profileuRl = ''.obs;

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
          var jsonResponse = response.data['data'];

          List<dynamic> dataEx = jsonResponse;

          singleChat.value =
              (dataEx).map((e) => SingleMessageModel.fromMap(e)).toList().obs;

          singleChatTem.value = List.from(singleChat);

          var myList = List.from(singleChat);
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
          if (response.statusCode == 200) {
            var data = json.decode(response.body);
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  //==============================DOWNLOADING====================

  static Future<void> download(String urlPath) async {
    log("Downloading");
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();
      final id = await FlutterDownloader.enqueue(
        url: urlPath,
        savedDir: externalDir!.path,
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      print('Permission deined');
    }
  }

  // Future<bool> checkPermission() async {
  //   if (platform == TargetPlatform.android) {
  //     final status = await Permission.storage.status;
  //     if (status != PermissionStatus.granted) {
  //       final result = await Permission.storage.request();
  //       if (result == PermissionStatus.granted) {
  //         return true;
  //       }
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     return true;
  //   }
  //   return false;
  // }

  // static Future<void> prepareSaveDir() async {
  //   localPath.value = (await _findLocalPath())!;

  //   final savedDir = Directory(localPath.value);
  //   bool hasExisted = await savedDir.exists();
  //   if (!hasExisted) {
  //     savedDir.create();
  //   }
  // }

  // static Future<String?> _findLocalPath() async {
  //   if (platform == TargetPlatform.android) {
  //     String dir = (await getExternalStorageDirectory())!.path;
  //     // String dir = "/sdcard/downloads";
  //     return dir;
  //   } else {
  //     var directory = await getApplicationDocumentsDirectory();
  //     return directory.path + Platform.pathSeparator + 'Download';
  //   }
  // }

  // static Future<void> downloadNow(
  //     String urlPath, String filename, int index) async {
  //   await prepareSaveDir();
  //   try {
  //     final extension = p.extension(urlPath);
  //     await Dio()
  //         .download("$urlPath", localPath.value + "/" + "$filename.$extension",
  //             onReceiveProgress: (received, total) {
  //       percentage.value = ((received / total) * 100).floor();
  //     });

  //     if (percentage.value > 0 && percentage.value < 100) {
  //       if (index == 1) {
  //         indexVar1.value = true;
  //       } else {
  //         indexVar2.value = true;
  //       }
  //     } else if (percentage.value == 100) {
  //       downLoadData.write(
  //           filename, localPath.value + "/" + "$filename$extension");
  //       downLoadData.write("checkFilename", filename);
  //     }
  //   } catch (e) {
  //     print("Download Failed.\n\n" + e.toString());
  //   }
  // }
}
