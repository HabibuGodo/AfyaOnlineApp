import 'dart:async';
import 'dart:developer';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../../theme/app_theme.dart';
import '../services/base_service.dart';
import 'global.dart';

class LoginOTPController extends GetxController {
  // count down timer
  var countDown = 0.obs;
  var timer = Timer.periodic(Duration(seconds: 1), (timer) {}).obs;
  late ThemeData theme;

// is loading
  var isLoading = false.obs;
  var profileImage = ''.obs;
  // var authdetails = <AuthDetails>[].obs;

  // count down timer function
  void startTimer() {
    countDown.value = 60;
    timer.value = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countDown.value > 0) {
        countDown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  // otp input textfield controllers
  // late OtpFieldController otpController = OtpFieldController();
  var otpinput = ''.obs;
  late var phone;

  // stop count down timer
  void stopTimer() {
    timer.value.cancel();
  }

  @override
  void onInit() {
    phone = Get.arguments['phone'];
    theme = AppTheme.communityTBTheme;

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    stopTimer();
  }

  // submit otp and login
  //check otp
  Future<void> checkOTP() async {
    EasyLoading.show(
      status: 'Please wait...',
      maskType: EasyLoadingMaskType.black,
    );

    try {
      final response = await http.post(
        Uri.parse(baseURL + '/check_otp'),
        headers: <String, String>{"Accept": "application/json"},
        body: {
          'otp': otpinput.value.toString(),
          'phone': phone.toString(),
        },
      );
      if (response.statusCode == 200) {
        EasyLoading.dismiss();

        final jsonResponse = convert.jsonDecode(response.body);

        log(jsonResponse.toString());

        if (response.body.contains("success")) {
          Get.snackbar('Success', 'OTP verified successfully',
              backgroundColor: Colors.green, colorText: Colors.white);

          authData.write('user_id', jsonResponse['user']['id']);
          authData.write('name', jsonResponse['user']['name']);
          authData.write('phone', jsonResponse['user']['phone']);
          authData.write('email', jsonResponse['user']['email']);
          authData.write('role', jsonResponse['user']['role_id']);
          authData.write('mrn', jsonResponse['user']['mrn']);
          authData.write(
              'profile_image', jsonResponse['user']['profile_image']);

          Global.profileuRl.value = jsonResponse['user']['profile_image'];

          if (jsonResponse['user']['firebaseToken'] == null) {
            Global.saveFirebaseToken();
          } else {
            // firebaseToken
            authData.write(
                'firebaseToken', jsonResponse['user']['firebaseToken']);
          }

          // authData.write('token', jsonResponse['token']);
          Global.verifyUser(
              jsonResponse['user']['email'], jsonResponse['user']['email']);
          pageBox.write('isLogged', true);

          Get.offAllNamed('/home');
        } else {
          await ArtSweetAlert.show(
            barrierDismissible: false,
            context: Get.context!,
            artDialogArgs: ArtDialogArgs(
                // denyButtonText: "Go back",
                // denyButtonColor: Colors.red,
                confirmButtonColor: theme.colorScheme.primary,
                title: 'Verification Failed',
                text:
                    "You have entered wrong OTP code. Please enter the correct code",
                confirmButtonText: "Go back",
                type: ArtSweetAlertType.danger),
          );
        }
      } else {
        EasyLoading.dismiss();

        await ArtSweetAlert.show(
          barrierDismissible: false,
          context: Get.context!,
          artDialogArgs: ArtDialogArgs(
              // denyButtonText: "Go back",
              // denyButtonColor: Colors.red,
              confirmButtonColor: theme.colorScheme.primary,
              title: 'Verification Failed',
              text:
                  "You have entered wrong OTP code. Please enter the correct code",
              confirmButtonText: "Go back",
              type: ArtSweetAlertType.danger),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }
}
