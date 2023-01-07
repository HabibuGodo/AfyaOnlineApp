import 'package:get/get.dart';

import '../services/local_storage.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    // FlutterAlarmClock.createAlarm(14, 38, title: "Muda wa kipindi cha 1");

    Future.delayed(const Duration(seconds: 0), () {
      // check if viewed onboard
      if (authData.read('isLogged') == true) {
        Get.offAndToNamed('/home');
      } else {
        // if (pageBox.read('viwedOnboard') == true) {
        Get.offAndToNamed('/login');
        // }

      }
    });
  }
}
