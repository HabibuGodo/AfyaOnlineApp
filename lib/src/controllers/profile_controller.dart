import 'dart:developer';
import 'dart:io';
import 'dart:convert' as convert;

import 'package:flutkit/src/controllers/global.dart';
import 'package:flutkit/src/services/base_service.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../views/login_screen.dart';

class ProfileController extends GetxController {
  var showLoading = true, uiLoading = true;

  late ThemeData theme;
  late ProfileController controller;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    theme = AppTheme.communityTBTheme;
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 1));

    showLoading = false;
    uiLoading = false;
    update();
  }

  var myPhoto = ''.obs;

  void uploadPhoto(ImageSource imageSource) async {
    // pick the image here
    final profileImage = await ImagePicker().pickImage(source: imageSource);

    // set the path to the image
    if (profileImage != null) {
      // File? image = await cropImage(imagefile: File(profileImage.path));
      myPhoto.value = profileImage.path;
      completeProfile();
      Get.back();
    } else {
      // get the snackbar here
      Get.snackbar('Error', 'No image selected');
    }
  }

  Future<void> completeProfile() async {
    EasyLoading.show(
      status: 'Please wait...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      if (myPhoto.value.isNotEmpty) {
        var userid = authData.read('user_id');

        var request =
            http.MultipartRequest('POST', Uri.parse('$baseURL/updateProfile'));
        //add request header
        request.headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Accept': 'application/json',
        });
        request.fields['user_id'] = userid.toString();
        request.files.add(await http.MultipartFile.fromPath(
            'profile_image', myPhoto.value.toString()));

        var response = await request.send();

        var data = await http.Response.fromStream(response);
        var jsonResponse = convert.jsonDecode(data.body);

        // get the student data
        log(jsonResponse.toString());

        if (data.body.contains('success')) {
          authData.write('profile_image', jsonResponse['profile_image']);

          Global.profileuRl.value = jsonResponse['user']['profile_image'];

          Get.snackbar(
            'Success',
            jsonResponse['message'],
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.green,
          );
        } else if (data.body.contains('error')) {
          Get.snackbar(
            'Error',
            jsonResponse['message'],
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
        } else {
          Get.snackbar(
            'Error',
            'Something Went Wrong...',
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
        }
      } else {
        // get the snackbar here
        Get.snackbar('Profile', 'No image selected');
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  String getTag() {
    return "profile_controller";
  }
}
