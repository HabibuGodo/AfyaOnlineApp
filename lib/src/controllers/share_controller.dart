import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../theme/app_theme.dart';
import '../models/newsfeed_model.dart';
import '../services/base_service.dart';

class ShareController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;

  late ThemeData theme;

  var newsFeeds = <NewsFeedModel>[].obs;

  // var downloadPort = ReceivePort().obs;
  // StreamController<String> eventController =
  //     StreamController<String>.broadcast();

  // Stream<String> get events {
  //   return eventController.stream;
  // }

  @override
  void onInit() async {
    getNewsFeeds();
    theme = AppTheme.communityTBTheme;

    // IsolateNameServer.registerPortWithName(
    //     Global.downloadPort.sendPort, 'downloader_send_port');

    // Global.broadcastStream.listen((dynamic data) {
    //   String id = data[0];
    //   DownloadTaskStatus downloadStatus = data[1];
    //   int progress = data[2];
    //   update();
    // });

    // FlutterDownloader.registerCallback(downloadCallback);
    // // Global.downloadPort.value.asBroadcastStream().listen((dynamic data) {
    // //   String id = data[0];
    // //   DownloadTaskStatus downloadStatus = data[1];
    // //   int progress = data[2];
    // //   update();
    // // });

    // FlutterDownloader.registerCallback(downloadCallback);

    //
    super.onInit();
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

  // fetch all categories
  Future<void> getNewsFeeds() async {
    try {
      Dio dio = Dio();
      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_categories"}));
      dio.options.headers["Content-Type"] = 'application/json';
      dio.interceptors.add(_dioCacheManager.interceptor);

      var response = await dio.get("$baseURL/newsfeed", options: cacheOptions);

      if (response.statusCode == 200) {
        List<dynamic> dataEx = response.data['data'];

        newsFeeds.value =
            (dataEx).map((e) => NewsFeedModel.fromMap(e)).toList().obs;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    } finally {
      showLoading.value = false;
      uiLoading.value = false;
    }
  }

  //edit news feed
  // Future<void> editNewsFeed(
  //     {required String id,
  //     required String title,
  //     required String description,
  //     required String imageFile,
  //     required String docFile,
  //     required String videoFile}) async {
  //   try {
  //     var request =
  //         http.MultipartRequest('POST', Uri.parse('$baseURL/editFeed/$id'));
  //     request.fields['title'] = title;
  //     request.fields['description'] = description;
  //     request.fields['image'] = imageFile;
  //     request.fields['file'] = docFile;
  //     request.fields['video'] = videoFile;
  //     request.headers['Accept'] = 'application/json';

  //     if (imageFile != '') {
  //       final File _file = File(imageFile);
  //       request.files.add(
  //         http.MultipartFile(
  //           'image',
  //           _file.readAsBytes().asStream(),
  //           _file.lengthSync(),
  //           filename: _file.path.split('/').last,
  //         ),
  //       );
  //     }

  //     if (docFile != '') {
  //       final File attachment = File(docFile);

  //       request.files.add(http.MultipartFile(
  //         'file',
  //         attachment.readAsBytes().asStream(),
  //         attachment.lengthSync(),
  //         filename: attachment.path.split('/').last,
  //       ));
  //     }

  //     if (videoFile != '') {
  //       final File attachment = File(videoFile);

  //       request.files.add(http.MultipartFile(
  //         'video',
  //         attachment.readAsBytes().asStream(),
  //         attachment.lengthSync(),
  //         filename: attachment.path.split('/').last,
  //       ));
  //     }

  //     var response = await request.send();
  //     var data = await http.Response.fromStream(response);

  //     if (response.statusCode == 200) {
  //       var jsonResponse = convert.jsonDecode(data.body);

  //       // snackbar

  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     showLoading.value = false;
  //     uiLoading.value = false;
  //   }
  // }

  Future<void> editNewsFeed({
    required String id,
    required String title,
    required String description,
    required String imageFile,
    required String docFile,
    required String videoFile,
    required String audioFile,
  }) async {
    EasyLoading.show(
      status: 'Please wait...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final response =
          await http.put(Uri.parse('$baseURL/editFeed/$id'), body: {
        "title": title,
        "description": description,
        "image": imageFile,
        "file": docFile,
        "video": videoFile,
        "audio": audioFile,
      }, headers: {
        "Accept": "application/json"
      });

      // Get.snackbar('Posted!', response.body.toString(),
      //     snackPosition: SnackPosition.TOP,
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white,
      //     duration: Duration(minutes: 1),
      //     icon: Icon(
      //       Icons.check_circle,
      //       color: Colors.white,
      //     ));

      if (response.body.contains("success")) {
        Get.snackbar('Posted!', 'Successfully Edited News Feed!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ));
        getNewsFeeds();
        // Get.offAndToNamed('/home');
        EasyLoading.dismiss();
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
      showLoading.value = false;
      uiLoading.value = false;
    }
  }

  Future<void> deleteNewsFeed({required String id}) async {
    EasyLoading.show(
      status: 'Please wait...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final response = await http.delete(Uri.parse('$baseURL/deleteFeed/$id'),
          headers: {"Accept": "application/json"});

      if (response.body.contains("success")) {
        Get.snackbar('Posted!', 'Successfully Delete News Feed!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ));
        getNewsFeeds();
        // Get.offAndToNamed('/home');
        EasyLoading.dismiss();
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
      showLoading.value = false;
      uiLoading.value = false;
    }
  }
}
