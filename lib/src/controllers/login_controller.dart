import 'dart:developer';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutkit/theme/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;

import '../../theme/app_theme.dart';
import '../../theme/constant.dart';
import '../services/base_service.dart';
import 'package:http/http.dart' as http;

class LogInController extends GetxController {
  var selectedRole = 1.obs;

  final loginFormKey = GlobalKey<FormState>().obs;

  late TextEditingController mrnController;
  late ThemeData theme;
  late OutlineInputBorder outlineInputBorder;
  var mrnNumber = ''.obs;
  var checkDataConnection = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    mrnController = TextEditingController();
    theme = AppTheme.communityTBTheme;
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

  String? validateMRN(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please provide your MRN.';
    }
    return null;
  }

  // Submit Form
  void checkValidation() async {
    final isValid = loginFormKey.value.currentState!.validate();
    if (!isValid) {
      print('Form has Errors....');
    } else {
      loginFormKey.value.currentState!.save();

      var result = await Connectivity().checkConnectivity();

      if (result == ConnectivityResult.none) {
        // EasyLoading.showError('No internet connection.');
        checkDataConnection.value = "No internet connection.";
        EasyLoading.showError(checkDataConnection.value);
      } else {
        bool result = await DataConnectionChecker().hasConnection;

        if (result == true) {
          await sendOTP();
        } else {
          EasyLoading.showError(checkDataConnection.value);
          checkDataConnection.value = "No internet connection.";
        }
      }
    }
  }

  // Call API to Posts phone number

  Future<void> sendOTP() async {
    EasyLoading.show(
      status: 'Please wait...',
      maskType: EasyLoadingMaskType.black,
    );

    try {
      var response = await http.post(
        Uri.parse(baseURL + '/send_otp'),
        body: {
          'mrn': mrnNumber.value,
        },
      );

      log(response.body.toString());

      if (response.body.contains('success')) {
        var jsonResponse = convert.jsonDecode(response.body);

        Get.toNamed('/login_otp', arguments: {'phone': jsonResponse['phone']});
      } else {
        EasyLoading.dismiss();

        await ArtSweetAlert.show(
            barrierDismissible: false,
            context: Get.context!,
            artDialogArgs: ArtDialogArgs(
                // denyButtonText: "Go back",
                // denyButtonColor: Colors.red,
                confirmButtonColor: theme.colorScheme.primary,
                title: 'Login Failed',
                text: "The user does not exist",
                confirmButtonText: "Go back",
                type: ArtSweetAlertType.danger));
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      await ArtSweetAlert.show(
          barrierDismissible: false,
          context: Get.context!,
          artDialogArgs: ArtDialogArgs(
              // denyButtonText: "Go back",
              // denyButtonColor: Colors.red,
              confirmButtonColor: theme.colorScheme.primary,
              title: 'Login Failed',
              text: e.toString(),
              confirmButtonText: "Go back",
              type: ArtSweetAlertType.danger));
    } finally {
      EasyLoading.dismiss();
    }
  }
}
