import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../models/newsfeed_model.dart';
import '../services/base_service.dart';

class ShareController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;

  late ThemeData theme;

  var newsFeeds = <NewsFeedModel>[].obs;

  @override
  void onInit() {
    getNewsFeeds();
    theme = AppTheme.communityTBTheme;
    super.onInit();
  }

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
}
