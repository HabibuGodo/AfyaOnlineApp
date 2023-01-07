import 'package:flutkit/src/controllers/login_controller.dart';
import 'package:flutkit/src/controllers/register_controller.dart';
import 'package:get/get.dart';

import '../controllers/login_otp_controller.dart';
import '../controllers/otp_controller.dart';

class OutsideBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogInController>(
      () => LogInController(),
    );

    Get.lazyPut<RegisterController>(
      () => RegisterController(),
    );

    Get.lazyPut<OTPController>(
      () => OTPController(),
    );

    Get.lazyPut<LoginOTPController>(
      () => LoginOTPController(),
    );
  }
}
