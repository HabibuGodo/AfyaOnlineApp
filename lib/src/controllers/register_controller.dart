import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import '../../theme/app_theme.dart';
import '../../theme/constant.dart';
import '../services/base_service.dart';

class RegisterController extends GetxController {
  late TextEditingController nameTE, emailTE, phoneNumberTE, idNumberTE;
  final registerKey = GlobalKey<FormState>().obs;
  late ThemeData theme;
  late OutlineInputBorder outlineInputBorder;
  var myPhoto = ''.obs;
  var idType = ''.obs;

  var selectedRole = ''.obs;
  var roleVerificatioon = false.obs;
  var firstTime = true.obs;
  var name = ''.obs;
  var phoneNumber = ''.obs;
  var email = ''.obs;
  var idNumber = ''.obs;
  var validated = false;

  late FocusNode nameFocusNode,
      emailFocusNode,
      phoneNumberFocusNode,
      idNumberFocusNode;

  @override
  void onInit() {
    nameTE = TextEditingController();
    emailTE = TextEditingController();
    phoneNumberTE = TextEditingController();
    idNumberTE = TextEditingController();
    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneNumberFocusNode = FocusNode();
    idNumberFocusNode = FocusNode();
    theme = AppTheme.communityTBTheme;
    outlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(Constant.textFieldRadius.medium)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
    super.onInit();
  }

  @override
  void onClose() {
    nameTE.dispose();
    emailTE.dispose();
    phoneNumberTE.dispose();
    idNumberTE.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    idNumberFocusNode.dispose();
    super.onClose();
  }

  List<String> ids = ['NIDA', 'Voter', 'Passport', 'License'].obs;

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter email";
    } else if (FxStringValidator.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  bool? validateRole(String? text) {
    if (text != '') {
      roleVerificatioon.value = true;
    } else {
      roleVerificatioon.value = false;
    }
    firstTime.value = false;

    return roleVerificatioon.value;
  }

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

  String? validateName(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your name.";
    } else if (!FxStringValidator.validateStringRange(text, 3)) {
      return "Your name length must not be less than 3 characters.";
    }
    return null;
  }

  String? validateIdNumber(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your id number.";
    }
    return null;
  }

  String? validateIdType(String? text) {
    if (text == null || text.isEmpty) {
      return "Please select your id type.";
    }
    return null;
  }

  // Future<File?> cropImage({required File imagefile}) async {
  //   CroppedFile? croppedImage =
  //       await ImageCropper().cropImage(sourcePath: imagefile.path);
  //       File? image = File(profileImage.path);
  //   if (croppedImage == null) return null;
  //   return File(croppedImage.path);
  // }

  void uploadPhoto(ImageSource imageSource) async {
    // pick the image here
    final profileImage = await ImagePicker().pickImage(source: imageSource);

    // set the path to the image
    if (profileImage != null) {
      // File? image = await cropImage(imagefile: File(profileImage.path));
      File? image = File(profileImage.path);
      myPhoto.value = image.path;

      Navigator.pop(Get.context!);
    } else {
      // get the snackbar here
      Get.snackbar('error', 'No image selected');

      Navigator.pop(Get.context!);
    }
  }

  // Submit Form
  void checkValidation() async {
    final isValid = registerKey.value.currentState!.validate();
    if (!isValid) {
      print('Form has Errors....');
    } else {
      registerKey.value.currentState!.save();

      validated = true;
    }
  }

  // Call API to Posts phone number
  Future<void> postPhoneNumber() async {
    EasyLoading.show(
      status: 'Please wait...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      // print("Phone:: ${phoneNumber.value}");

      final response =
          await http.post(Uri.parse("$baseURL/generate-otp"), body: {
        'phone': phoneNumber.value,
      }, headers: {
        "Accept": "application/json"
      });

      // check response if has errorr
      if (response.body.contains('The phone has already been taken.')) {
        EasyLoading.dismiss();

        await ArtSweetAlert.show(
            barrierDismissible: false,
            context: Get.context!,
            artDialogArgs: ArtDialogArgs(
                // denyButtonText: "Go back",
                // denyButtonColor: Colors.red,
                confirmButtonColor: theme.colorScheme.primary,
                title: 'Verification Failed',
                text: "The phone has already been taken.",
                confirmButtonText: "Go back",
                type: ArtSweetAlertType.danger));
      } else if (response.body.contains('otp')) {
        EasyLoading.dismiss();

        Get.toNamed('/otp_screen', arguments: {
          'name': name.value,
          'phone': phoneNumber.value,
          'email': email.value,
          'role': selectedRole.value,
          'id_type': idType.value,
          'id_no': idNumber.value,
        });
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
                text: "Something went wrong, try again later...',",
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
