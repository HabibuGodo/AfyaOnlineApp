import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;

import '../../animations/auth/teddy_controller.dart';
import '../../theme/app_theme.dart';
import '../../theme/constant.dart';
import '../services/base_service.dart';
import '../views/forgot_password_screen.dart';
import 'package:http/http.dart' as http;

class LogInController extends GetxController {
  var selectedRole = 1.obs;

  final loginFormKey = GlobalKey<FormState>().obs;

  late TextEditingController mrnController;
  late TeddyController teddyController;
  late ThemeData theme;
  late OutlineInputBorder outlineInputBorder;
  var mrnNumber = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    mrnController = TextEditingController();
    theme = AppTheme.reconSpotTheme;
    teddyController = TeddyController();
    outlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(Constant.textFieldRadius.medium)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
    mrnController.dispose();
  }

  void goToForgotPasswordScreen() {
    Navigator.of(Get.context!, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ForgotPasswordScreen(),
      ),
    );
  }

  // void login() {
  //   if (loginFormKey.value.currentState!.validate()) {
  //     Navigator.of(Get.context!, rootNavigator: true).push(
  //       MaterialPageRoute(
  //         builder: (context) => Dashboard(),
  //       ),
  //     );
  //   }
  // }

  // void login1() {
  //   if (loginFormKey.value.currentState!.validate()) {
  //     Navigator.of(Get.context!, rootNavigator: true).push(
  //       MaterialPageRoute(
  //         builder: (context) => Dashboard(),
  //       ),
  //     );
  //   }
  // }

  String? validatePhoneNo(String? value) {
    Pattern pattern = r"^[0-9]{10,10}$";
    RegExp regex = RegExp(pattern.toString());
    if (value == null || value.isEmpty) {
      return 'Please provide your phone number.';
    } else if (value.length < 10) {
      return 'Phone number must not be less than 10 digits.';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Please enter a valid phone number';
      } else {
        if ((value.startsWith("0", 0) && value.startsWith("6", 1)) ||
            (value.startsWith("0", 0) && value.startsWith("7", 1)) &&
                value.length == 10) {
          return null;
        } else {
          return 'Please enter a valid phone number';
        }
      }
    }
  }

  // Submit Form
  void checkValidation() {
    final isValid = loginFormKey.value.currentState!.validate();
    if (!isValid) {
      print('Form has Errors....');
    } else {
      loginFormKey.value.currentState!.save();
      authData.write('mrnNumber', mrnNumber.value);
      sendOTP();
    }
  }

  // Call API to Posts phone number
  Future<void> sendOTP() async {
    EasyLoading.show(
      status: 'Please wait...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final response = await http.post(
        Uri.parse(baseURL + '/login'),
        body: {
          'username': mrnNumber.value,
        },
      );

      // check response if has errorr
      if (response.body.contains('Invalid user')) {
        EasyLoading.dismiss();

        await ArtSweetAlert.show(
            barrierDismissible: false,
            context: Get.context!,
            artDialogArgs: ArtDialogArgs(
                // denyButtonText: "Go back",
                // denyButtonColor: Colors.red,
                confirmButtonColor: theme.colorScheme.primary,
                title: 'Login Failed',
                text: "The user does not exist, please register",
                confirmButtonText: "Go back",
                type: ArtSweetAlertType.danger));
      } else {
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);

          Get.toNamed('/login_otp',
              arguments: {'id': jsonResponse['user']['id']});
        }
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }
}
