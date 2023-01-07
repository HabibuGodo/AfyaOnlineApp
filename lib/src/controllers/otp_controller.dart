import 'dart:async';
import 'dart:convert' as convert;
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../services/base_service.dart';
import '../services/local_storage.dart';

class OTPController extends GetxController {
  // count down timer
  var countDown = 0.obs;
  var timer = Timer.periodic(Duration(seconds: 1), (timer) {}).obs;

  // late OtpFieldController otpController = OtpFieldController();
  var otpinput = ''.obs;

// is loading
  var isLoading = false.obs;
  // var createdStudent = <Student>[].obs;

  // count down timer function
  late ThemeData theme;
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

  late var name;
  late var phone;
  late var email;
  late var role;
  late var idType;
  late var idNumber;

  // otp input textfield controllers

  // stop count down timer
  void stopTimer() {
    timer.value.cancel();
  }

  @override
  void onInit() {
    super.onInit();
    theme = AppTheme.reconSpotTheme;

    name = Get.arguments['name'];
    phone = Get.arguments['phone'];
    email = Get.arguments['email'];
    role = Get.arguments['role'];
    idType = Get.arguments['id_type'];
    idNumber = Get.arguments['id_no'];

    startTimer();
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

  //check otp
  Future<void> checkOTP() async {
    EasyLoading.show(
      status: 'Please wait...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final response = await http.post(
        Uri.parse(baseURL + '/verifyOtp'),
        headers: <String, String>{"Accept": "application/json"},
        body: {
          'otp': otpinput.value.toString(),
          'phone': phone.toString(),
        },
      );

      if (response.body.contains('otp verified')) {
        registerUser();
      } else if (response.body.contains('invalid otp')) {
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
                type: ArtSweetAlertType.danger));
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
                text: "Something went wrong, try again later...",
                confirmButtonText: "Go back",
                type: ArtSweetAlertType.danger));
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  // POST Image API
  Future<void> registerUser() async {
    EasyLoading.show(
      status: 'Please wait...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final response = await http.post(
        Uri.parse(baseURL + '/register'),
        headers: <String, String>{"Accept": "application/json"},
        body: {
          'name': name.toString(),
          'phone': phone.toString(),
          'email': email.toString(),
          'role': role.toString(),
          'id_type': idType.toString(),
          'id_no': idNumber.toString(),
        },
      );

      // create dynamic list of students
      // var students = <Student>[];
      print(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();

        var jsonResponse = convert.jsonDecode(response.body);
        if (response.body.contains("token")) {
          authData.write('user_id', jsonResponse['user']['id']);
          authData.write('name', jsonResponse['user']['name']);
          authData.write('phone', jsonResponse['user']['phone']);
          authData.write('email', jsonResponse['user']['email']);
          authData.write('role', jsonResponse['user']['role']);
          authData.write('token', jsonResponse['token']);

          pageBox.write('isLogged', true);

          Get.offAllNamed('/home');
        }

        // snackbar
        Get.snackbar('Registered!',
            'Successfully Registered In Reacon Spot, Just Login!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ));
      } else {
        EasyLoading.dismiss();

        await ArtSweetAlert.show(
            barrierDismissible: false,
            context: Get.context!,
            artDialogArgs: ArtDialogArgs(
                // denyButtonText: "Go back",
                // denyButtonColor: Colors.red,
                confirmButtonColor: theme.colorScheme.primary,
                title: 'Registration Failed',
                text: "Registration failed, Please try again!",
                confirmButtonText: "Go back",
                type: ArtSweetAlertType.danger));
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }
}
