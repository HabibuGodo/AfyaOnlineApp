import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  late ThemeData theme;
  late TabController tabController;

  late final TickerProvider tickerProvider;

  // iniitialize counter
  @override
  void onInit() {
    super.onInit();
    // getbanners();
    EasyLoading.dismiss();
    theme = AppTheme.communityTBTheme;

    //
  }

  handleTabSelection(var index) {
    currentIndex.value = index;
    // update();
  }
}
