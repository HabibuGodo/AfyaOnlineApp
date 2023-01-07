import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:flutkit/images.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:get/get.dart';

import '../../../theme/constant.dart';
import '../controllers/register_controller.dart';

class Register1Screen extends GetView<RegisterController> {
  const Register1Screen({key});
  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Obx(
      () => Scaffold(
        body: ListView(
          padding: FxSpacing.fromLTRB(
              20, FxSpacing.safeAreaTop(Get.context!) + 36, 20, 20),
          children: [
            FxText.displaySmall(
              'Hello! \nChoose Who Are You',
              fontWeight: 700,
              color: controller.theme.colorScheme.primary,
            ),
            FxSpacing.height(30),
            Form(
              key: controller.registerKey.value,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FxContainer.bordered(
                        border: Border.all(
                            color: controller.selectedRole.value == 'Mteja'
                                ? controller.theme.colorScheme.primary
                                : Colors.transparent),
                        padding: FxSpacing.xy(28, 20),
                        borderRadiusAll: Constant.containerRadius.medium,
                        onTap: () {
                          controller.selectedRole.value = "Mteja";
                          controller.idType.value = '';
                        },
                        child: Column(
                          children: [
                            Image(
                              height: 64,
                              width: 64,
                              image: AssetImage(Images.student),
                            ),
                            FxSpacing.height(12),
                            FxText.bodySmall(
                              'Mteja',
                              fontWeight: 600,
                              color: controller.selectedRole.value == 'Mteja'
                                  ? controller.theme.colorScheme.primary
                                  : controller.theme.colorScheme.onBackground,
                            ),
                          ],
                        ),
                      ),
                      FxContainer.bordered(
                        border: Border.all(
                            color: controller.selectedRole.value == 'Dalali'
                                ? controller.theme.colorScheme.primary
                                : Colors.transparent),
                        padding: FxSpacing.xy(28, 20),
                        borderRadiusAll: Constant.containerRadius.medium,
                        onTap: () {
                          controller.selectedRole.value = "Dalali";
                        },
                        child: Column(
                          children: [
                            Image(
                              height: 64,
                              width: 64,
                              image: AssetImage(Images.teacher),
                            ),
                            FxSpacing.height(12),
                            FxText.bodySmall(
                              'Dalali',
                              fontWeight: 600,
                              color: controller.selectedRole.value == 'Dalali'
                                  ? controller.theme.colorScheme.primary
                                  : controller.theme.colorScheme.onBackground,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  FxSpacing.height(10),
                  controller.roleVerificatioon.value == false &&
                          controller.firstTime.value == false
                      ? Text(
                          "You must choose between Dalali or Mteja",
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                  FxSpacing.height(20),
                  TextFormField(
                    style: FxTextStyle.bodyMedium(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        isDense: true,
                        fillColor:
                            controller.theme.primaryColor.withOpacity(0.4),
                        prefixIcon: Icon(
                          FeatherIcons.user,
                          color: controller.theme.colorScheme.onBackground,
                        ),
                        hintText: "Name",
                        enabledBorder: controller.outlineInputBorder,
                        focusedBorder: controller.outlineInputBorder,
                        border: controller.outlineInputBorder,
                        contentPadding: FxSpacing.all(16),
                        hintStyle: FxTextStyle.bodyMedium(),
                        isCollapsed: true),
                    maxLines: 1,
                    controller: controller.nameTE,
                    validator: controller.validateName,
                    cursorColor: controller.theme.colorScheme.onBackground,
                    onSaved: (value) {
                      controller.name.value = value.toString();
                    },
                  ),
                  FxSpacing.height(20),
                  TextFormField(
                    style: FxTextStyle.bodyMedium(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        isDense: true,
                        fillColor:
                            controller.theme.primaryColor.withOpacity(0.4),
                        prefixIcon: Icon(
                          FeatherIcons.mail,
                          color: controller.theme.colorScheme.onBackground,
                        ),
                        hintText: "Email Address",
                        enabledBorder: controller.outlineInputBorder,
                        focusedBorder: controller.outlineInputBorder,
                        border: controller.outlineInputBorder,
                        contentPadding: FxSpacing.all(16),
                        hintStyle: FxTextStyle.bodyMedium(),
                        isCollapsed: true),
                    maxLines: 1,
                    controller: controller.emailTE,
                    validator: controller.validateEmail,
                    cursorColor: controller.theme.colorScheme.onBackground,
                    onSaved: (value) {
                      controller.email.value = value.toString();
                    },
                  ),
                  FxSpacing.height(20),
                  TextFormField(
                    style: FxTextStyle.bodyMedium(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        isDense: true,
                        fillColor:
                            controller.theme.primaryColor.withOpacity(0.4),
                        prefixIcon: Icon(
                          FeatherIcons.phone,
                          color: controller.theme.colorScheme.onBackground,
                        ),
                        hintText: "Phone Number",
                        enabledBorder: controller.outlineInputBorder,
                        focusedBorder: controller.outlineInputBorder,
                        border: controller.outlineInputBorder,
                        contentPadding: FxSpacing.all(16),
                        hintStyle: FxTextStyle.bodyMedium(),
                        isCollapsed: true),
                    maxLines: 1,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    controller: controller.phoneNumberTE,
                    cursorColor: controller.theme.colorScheme.onBackground,
                    validator: (value) => controller.validatePhoneNo(value),
                    onSaved: (value) {
                      controller.phoneNumber.value =
                          value.toString().replaceFirst("0", "255");
                    },
                  ),
                ],
              ),
            ),
            FxSpacing.height(20),
            controller.selectedRole.value == 'Dalali'
                ? Container(
                    decoration: BoxDecoration(
                      color: controller.theme.primaryColor,
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: DropdownButtonFormField(
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Select ID Type ",
                          prefixIcon: Icon(Icons.card_membership,
                              color: controller.theme.colorScheme.primary),
                        ),
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              "NIDA",
                              style: FxTextStyle.bodyMedium(),
                            ),
                            value: "NIDA",
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "Voter",
                              style: FxTextStyle.bodyMedium(),
                            ),
                            value: "Voter",
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "Passport",
                              style: FxTextStyle.bodyMedium(),
                            ),
                            value: "Passport",
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "License",
                              style: FxTextStyle.bodyMedium(),
                            ),
                            value: "License",
                          ),
                        ],
                        onChanged: (String? value) =>
                            controller.idType.value = value!.toString(),
                        validator: (value) =>
                            controller.validateIdType(value.toString()),
                        onSaved: (newValue) =>
                            controller.idType.value = newValue!.toString()))
                : Container(),
            controller.selectedRole.value == 'Dalali' &&
                    controller.idType.value != ''
                ? FxSpacing.height(20)
                : Container(),
            controller.selectedRole.value == 'Dalali' &&
                    controller.idType.value != ''
                ? TextFormField(
                    style: FxTextStyle.bodyMedium(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        isDense: true,
                        fillColor:
                            controller.theme.primaryColor.withOpacity(0.4),
                        // prefixIcon: Icon(
                        //   FeatherIcons.di,
                        //   color: theme.colorScheme.onBackground,
                        // ),
                        hintText: "Id Number",
                        enabledBorder: controller.outlineInputBorder,
                        focusedBorder: controller.outlineInputBorder,
                        border: controller.outlineInputBorder,
                        contentPadding: FxSpacing.all(16),
                        hintStyle: FxTextStyle.bodyMedium(),
                        isCollapsed: true),
                    maxLines: 1,
                    controller: controller.idNumberTE,
                    cursorColor: controller.theme.colorScheme.onBackground,
                    validator: controller.validateIdNumber,
                    onSaved: (value) {
                      controller.idNumber.value = value.toString();
                    },
                  )
                : Container(),
            FxSpacing.height(20),
            FxButton.block(
              elevation: 0,
              borderRadiusAll: Constant.buttonRadius.large,
              onPressed: () {
                // Get.toNamed('/register2');
                controller.checkValidation();
                controller.validateRole(controller.selectedRole.value);
                if (controller.validated == true &&
                    controller.roleVerificatioon.value == true) {
                  controller.postPhoneNumber();
                }
              },
              splashColor: controller.theme.colorScheme.onPrimary.withAlpha(30),
              backgroundColor: controller.theme.colorScheme.primary,
              child: FxText.labelLarge(
                "Sign Up",
                color: controller.theme.colorScheme.onPrimary,
              ),
            ),
            FxSpacing.height(16),
            Center(
              child: FxButton.text(
                onPressed: () {
                  Get.toNamed("/login");
                },
                padding: FxSpacing.zero,
                splashColor: controller.theme.colorScheme.primary.withAlpha(40),
                child: FxText.bodySmall("Already have an account?",
                    color: controller.theme.colorScheme.primary,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
