import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutkit/src/services/base_service.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../theme/app_theme.dart';
import '../../models/user_model.dart';

class UserToAddController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  var allUserNotInGroupTemList = <UserModel>[].obs;
  var allUserNotInGroup = <UserModel>[].obs;

  var selectedIds = <int>[].obs;
  late var userId;
  late var groupId;
  late var groupName;

  late ThemeData theme;
  @override
  void onInit() {
    theme = AppTheme.communityTBTheme;
    userId = authData.read('user_id').toString();
    groupId = Get.arguments['groupId'].toString();
    groupName = Get.arguments['groupName'].toString();

    getUserListToAdd(userId, groupId);
    super.onInit();
  }

//======================Single chat User List
  Future<void> getUserListToAdd(String myId, String selectedGroup) async {
    showLoading.value = true;
    uiLoading.value = true;
    try {
      // categories.value = Category.categoryList();

      Dio dio = Dio();

      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_userstoadd"}));
      dio.interceptors.add(_dioCacheManager.interceptor);

      final response = await dio.get(
        '$baseURL/usersNotInGroup/$myId/$selectedGroup',
        options: cacheOptions,
      );

      if (response.statusCode == 200) {
        // decode response to observable list
        // log(response.data);
        var jsonResponse = response.data['data'];

        List<dynamic> dataEx = jsonResponse;

        allUserNotInGroup.value =
            (dataEx).map((e) => UserModel.fromMap(e)).toList().obs;

        allUserNotInGroupTemList.value = List.from(allUserNotInGroup);
        // EasyLoading.dismiss();
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

  void filterUsersList(String value) {
    if (value.isNotEmpty) {
      allUserNotInGroup.value = allUserNotInGroupTemList
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList()
          .obs;
    } else {
      allUserNotInGroup.value = List.from(allUserNotInGroupTemList);
    }
  }

  //save groupmember
  Future<void> saveGroupMember(String groupId, List<int> selectedIds) async {
    showLoading.value = true;
    uiLoading.value = true;
    try {
      // categories.value = Category.categoryList();

      Dio dio = Dio();

      //send list of ids
      final response = await http.post(
        Uri.parse(baseURL + '/saveGroupMembers'),
        headers: <String, String>{"Accept": "application/json"},
        body: {
          "groupId": groupId.toString(),
          "selectedUsers": jsonEncode(selectedIds.toList()),
        },
      );
      log(groupId.toString());

      log(response.body.toString());
      if (response.statusCode == 200) {
        //snackbar============================
        Get.snackbar(
          "Success",
          "Group member added successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        getUserListToAdd(userId, groupId);

        // Get.toNamed('/group_chat', arguments: {
        //   'groupId': groupId,
        //   'groupName': groupName,
        //   'checkRoute': "group"
        // });
      } else {
        Get.snackbar(
          "Failed",
          "Fail to add group member",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
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
