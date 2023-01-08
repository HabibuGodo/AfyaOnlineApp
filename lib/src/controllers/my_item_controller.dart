import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../../theme/app_theme.dart';
import '../models/category.dart';
import '../models/house.dart';
import '../models/items_model.dart';
import '../services/base_service.dart';
import '../services/local_storage.dart';

class MyItemController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;

  var categories = <Category>[].obs;
  late ThemeData theme;
  // var packageList = <ItemsModel>[].obs;

  var items = <ItemsModel>[].obs;
  List selectedBedRooms = [].obs;
  List selectedBathRooms = [].obs;
  var selectedRange = RangeValues(200, 800).obs;

  @override
  void onInit() {
    EasyLoading.dismiss();
    getItems();
    theme = AppTheme.communityTBTheme;

    super.onInit();
  }

// fetch dalali all items here
  Future<void> getItems() async {
    showLoading.value = true;
    uiLoading.value = true;
    try {
      // categories.value = Category.categoryList();

      Dio dio = Dio();

      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_items"}));
      dio.options.headers["Authorization"] = "Bearer ${authData.read("token")}";
      dio.interceptors.add(_dioCacheManager.interceptor);

      var response = await dio.get(
        '$baseURL/my-product',
        options: cacheOptions,
      );

      if (response.statusCode == 200) {
        // decode response to observable list
        var jsonResponse = response.data;

        List<dynamic> dataEx = jsonResponse;

        items.value = (dataEx).map((e) => ItemsModel.fromMap(e)).toList().obs;
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
