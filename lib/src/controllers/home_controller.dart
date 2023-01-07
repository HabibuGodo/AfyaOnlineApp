import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../models/categories_model.dart';
import '../models/items_model.dart';
import '../services/base_service.dart';
import '../services/local_storage.dart';

class HomeController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  var selectedCategory = "ALL".obs;

  var categoriesList = <AllCategoryModel>[].obs;
  late ThemeData theme;

  var items = <ItemsModel>[].obs;
  List selectedBedRooms = [].obs;
  List selectedBathRooms = [].obs;
  var selectedRange = RangeValues(200, 800).obs;

  @override
  void onInit() {
    getItems();
    theme = AppTheme.reconSpotTheme;
    itemCategoriesList();
    super.onInit();
  }

  // fetch dalali all items here
  Future<void> getItems() async {
    try {
      // categories.value = Category.categoryList();

      Dio dio = Dio();

      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_items"}));
      dio.options.headers["Authorization"] = "Bearer ${authData.read("token")}";
      dio.interceptors.add(_dioCacheManager.interceptor);

      showLoading.value = true;
      uiLoading.value = true;
      var response = await dio.get(
        '$baseURL/product',
        options: cacheOptions,
      );

      if (response.statusCode == 200) {
        // decode response to observable list
        var jsonResponse = response.data;

        List<dynamic> dataEx = jsonResponse;

        items.value = (dataEx).map((e) => ItemsModel.fromMap(e)).toList().obs;
        showLoading.value = false;
        uiLoading.value = false;
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

  // fetch dalali all items here
  Future<void> getFilteredItems(String param) async {
    try {
      // categories.value = Category.categoryList();

      Dio dio = Dio();

      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_filtered_items"}));
      dio.options.headers["Authorization"] = "Bearer ${authData.read("token")}";
      dio.interceptors.add(_dioCacheManager.interceptor);
      var response;
      if (param == "ALL") {
        showLoading.value = true;
        uiLoading.value = true;
        response = await dio.get(
          '$baseURL/product',
          options: cacheOptions,
        );
      } else {
        showLoading.value = true;
        uiLoading.value = true;
        response = await dio.get(
          '$baseURL/product-category/$param',
          options: cacheOptions,
        );
      }

      if (response.statusCode == 200) {
        // decode response to observable list
        var jsonResponse = response.data;
        items.clear();
        List<dynamic> dataEx = jsonResponse;

        items.value = (dataEx).map((e) => ItemsModel.fromMap(e)).toList().obs;
        showLoading.value = false;
        uiLoading.value = false;
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

//FETCH TO CATEGORIES
  Future<void> itemCategoriesList() async {
    showLoading.value = false;
    uiLoading.value = false;
    try {
      Dio dio = Dio();
      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_categories"}));
      dio.options.headers["Authorization"] = "Bearer ${authData.read("token")}";
      dio.options.headers["Content-Type"] = 'application/json';
      dio.options.headers["Accept"] = "Bearer ${authData.read("token")}";
      dio.interceptors.add(_dioCacheManager.interceptor);

      var response = await dio.get("$baseURL/category", options: cacheOptions);

      if (response.statusCode == 200) {
        var jsonData = response.data;

        categoriesList = (jsonData as List)
            .map((e) => AllCategoryModel.fromJson(e))
            .toList()
            .obs;

        // categoriesList.insert(0, );
        categoriesList.insert(
            0,
            AllCategoryModel(
                name: 'ALL', id: 'ALL', subcategories: [], categoryId: ''));
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    } finally {
      showLoading.value = false;
      uiLoading.value = false;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
