import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutkit/src/models/conversationModel.dart';
import 'package:flutkit/src/models/group_model.dart';
import 'package:flutkit/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutx/flutx.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../theme/constant.dart';
import '../models/chat.dart';
import '../services/base_service.dart';
import '../services/local_storage.dart';

class ChatController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  var chats = <Chat>[].obs;
  final addGroupKey = GlobalKey<FormState>().obs;
  late TextEditingController groupNameTE;
  var groupName = ''.obs;

  late ThemeData theme;
  var groups = <GroupModel>[].obs;
  var groupsTemList = <GroupModel>[].obs;
  var allConvoTemList = <CoversatationModel>[].obs;
  var allConvo = <CoversatationModel>[].obs;
  var allUserTemList = <UserModel>[].obs;
  var allUser = <UserModel>[].obs;
  late var userId;
  late OutlineInputBorder outlineInputBorder;
  var validated1 = false.obs;

  @override
  void onInit() {
    groupNameTE = TextEditingController();
    fetchData();
    theme = AppTheme.communityTBTheme;
    outlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(Constant.textFieldRadius.medium)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
    userId = authData.read("user_id");
    getGroups();
    getConvoList();
    getUserList();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    groupNameTE.dispose();
  }

  String? validateGName(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter group name";
    }
    return null;
  }

  void checkValidation1() async {
    final isValid = addGroupKey.value.currentState!.validate();
    if (!isValid) {
      print('Form has Errors....');
    } else {
      addGroupKey.value.currentState!.save();
      validated1.value = true;
    }
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 1));

    chats.value = await Chat.getDummyList();

    showLoading.value = false;
    uiLoading.value = false;
    update();
  }

  void filterGroupList(String value) {
    if (value.isNotEmpty) {
      groups.value = groupsTemList
          .where((element) =>
              element.groupName!.toLowerCase().contains(value.toLowerCase()))
          .toList()
          .obs;
    } else {
      groups.value = List.from(groupsTemList);
    }
  }

  void filterUsersList(String value) {
    if (value.isNotEmpty) {
      allUser.value = allUserTemList
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList()
          .obs;
    } else {
      allUser.value = List.from(allUserTemList);
    }
  }

  //create group

  Future<void> createGroup() async {
    EasyLoading.show(
      status: 'Sending...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final response =
          await http.post(Uri.parse('$baseURL/create_group'), body: {
        "name": groupName.value.toString(),
      }, headers: {
        "Accept": "application/json"
      });

      if (response.body.contains("success")) {
        // snackbar
        Get.snackbar('Success!',
            'Successfully Create Group ${groupName.value.toString()}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ));
        // getGroups();
        groups.refresh();
        groupName.value = '';
        groupNameTE.clear();
        Get.offAndToNamed('/home');
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

  //============ fetch all groups here
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
        var jsonResponse = response.data['data'];

        List<dynamic> dataEx = jsonResponse;

        groups.value = (dataEx).map((e) => GroupModel.fromMap(e)).toList().obs;

        groupsTemList.value = List.from(groups);
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

  //======================Single chat Convo List
  Future<void> getConvoList() async {
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
        '$baseURL/conversations/$userId',
        options: cacheOptions,
      );

      if (response.statusCode == 200) {
        // decode response to observable list
        // log(response.data);
        var jsonResponse = response.data['data'];

        List<dynamic> dataEx = jsonResponse;

        allConvo.value =
            (dataEx).map((e) => CoversatationModel.fromMap(e)).toList().obs;

        allConvoTemList.value = List.from(allConvo);

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

  //======================Single chat User List
  Future<void> getUserList() async {
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
        '$baseURL/users/$userId',
        options: cacheOptions,
      );

      if (response.statusCode == 200) {
        // decode response to observable list
        // log(response.data);
        var jsonResponse = response.data['data'];

        List<dynamic> dataEx = jsonResponse;

        allUser.value = (dataEx).map((e) => UserModel.fromMap(e)).toList().obs;

        allUserTemList.value = List.from(allUser);
        log(allUser.toString());
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
