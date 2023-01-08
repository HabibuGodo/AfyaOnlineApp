import 'dart:developer';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../../theme/app_theme.dart';
import '../models/category.dart';
import '../models/favorite_model.dart';
import '../models/house.dart';
import '../models/items_model.dart';
import '../services/base_service.dart';
import '../services/local_storage.dart';

class MyFavoriteController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;

  var categories = <CategoryFavorite>[].obs;
  late ThemeData theme;
  // var packageList = <ItemsModel>[].obs;

  var favorite = <FavoriteModel>[].obs;
  var selectedRange = RangeValues(200, 800).obs;

  @override
  void onInit() {
    getFavoriteItems();
    theme = AppTheme.communityTBTheme;

    super.onInit();
  }

// fetch dalali all items here
  Future<void> getFavoriteItems() async {
    showLoading.value = true;
    uiLoading.value = true;
    try {
      // categories.value = CategoryFavorite.categoryList();

      Dio dio = Dio();

      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_items"}));
      dio.options.headers["Authorization"] = "Bearer ${authData.read("token")}";
      dio.interceptors.add(_dioCacheManager.interceptor);

      var response = await dio.get(
        '$baseURL/favourite',
        options: cacheOptions,
      );

      if (response.statusCode == 200) {
        // decode response to observable list
        var jsonResponse = response.data;

        List<dynamic> dataEx = jsonResponse;

        favorite.value =
            (dataEx).map((e) => FavoriteModel.fromMap(e)).toList().obs;
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
