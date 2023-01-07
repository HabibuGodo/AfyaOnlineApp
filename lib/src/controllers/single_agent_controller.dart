import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutkit/src/models/items_model.dart';
import 'package:flutkit/src/views/single_house_screen.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../models/agent.dart';
import '../models/house.dart';
import '../services/base_service.dart';
import '../services/local_storage.dart';

class SingleAgentController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  late ThemeData theme;

  var items = <ItemsModel>[].obs;
  late User agent;

  @override
  void onInit() {
    theme = AppTheme.reconSpotTheme;
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 1));

    showLoading.value = false;
    uiLoading.value = false;
    agent = Get.arguments['agent'];
    getItems();
  }

  // fetch dalali all items here
  Future<void> getItems() async {
    showLoading.value = true;
    uiLoading.value = true;
    try {
      Dio dio = Dio();

      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_items"}));
      dio.options.headers["Authorization"] = "Bearer ${authData.read("token")}";
      dio.interceptors.add(_dioCacheManager.interceptor);

      var response = await dio.get('$baseURL/my-product',
          options: cacheOptions, queryParameters: {'id': agent.id});

      if (response.statusCode == 200) {
        // decode response to observable list
        var jsonResponse = response.data;

        List<dynamic> dataEx = jsonResponse;

        items.value = (dataEx).map((e) => ItemsModel.fromMap(e)).toList().obs;
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

  @override
  String getTag() {
    return "single_agent_controller";
  }
}
