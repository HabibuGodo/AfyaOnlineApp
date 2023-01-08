import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_theme.dart';
import '../models/items_model.dart';
import '../services/base_service.dart';
import '../services/local_storage.dart';

class SingleHouseController extends GetxController {
  var showLoading = true.obs, uiLoading = true.obs;
  late ThemeData theme;
  var currentSlider = 0.obs;

  @override
  void onInit() {
    getHouse();
    theme = AppTheme.communityTBTheme;

    super.onInit();
  }

  late ItemsModel house;

  getHouse() async {
    await Future.delayed(Duration(seconds: 1));
    showLoading.value = false;
    uiLoading.value = false;
    house = Get.arguments['house'];
    // update();
  }

  handleSliderChange(var index) {
    currentSlider.value = index;
    // update();
  }

  Future<void> favoriteProduct(String productId) async {
    log("IDDDDDDDD ${authData.read('token')}");
    try {
      final response = await http.post(
        Uri.parse('$baseURL/favourite'),
        body: {
          'product': productId,
        },
        headers: {
          'Authorization': 'Bearer ${authData.read('token')}',
        },
      );

      // log("IDDDDDDDD ${authData.read('token')}");

      if (response.statusCode == 200) {
        Get.snackbar('Favorited!', 'Successfully Favorited this Item',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ));
      }
    } catch (e) {
      log("EROOOOOR ${e.toString()}");
    }
  }
}
