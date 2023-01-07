import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../componets/app_images.dart';
import '../controllers/splash_controller.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({key});

  @override
  Widget build(BuildContext context) {
//  return splash screen
    return SafeArea(
      child: Scaffold(
        // backgroundColor: appColor,
        body: GetBuilder<SplashController>(
          init: SplashController(),
          builder: (controller) {
            return Center(
              child: Image.asset(
                logo,
                // color: whietColor,
                height: 100,
                width: 100,
              ),
            );
          },
        ),
      ),
    );
  }
}
