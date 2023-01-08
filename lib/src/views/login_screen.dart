import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../theme/constant.dart';
import '../controllers/login_controller.dart';
import '../componets/shared_function.controller.dart';

class LoginScreen extends GetView<LogInController> {
  const LoginScreen({key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(child: _buildBody()));
  }

  Widget _buildBody() {
    return Obx(
      () => WillPopScope(
        onWillPop: SharedFunctionController.onWillPop,
        child: Scaffold(
          body: Padding(
            padding: FxSpacing.fromLTRB(
                16, FxSpacing.safeAreaTop(Get.context!) + 36, 16, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //     height: 200,
                //     padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                //     child: FlareActor(
                //       "assets/animations/rive/teddy.flr",
                //       shouldClip: false,
                //       alignment: Alignment.bottomCenter,
                //       fit: BoxFit.contain,
                //       controller: controller.teddyController,
                //     )),
                Center(
                  child: FxText.displaySmall(
                    'Hello Welcome',
                    fontWeight: 700,
                    color: controller.theme.primaryColor,
                  ),
                ),
                FxSpacing.height(40),

                Center(
                  child: Form(
                    key: controller.loginFormKey.value,
                    child: Column(
                      children: [
                        TextFormField(
                          style: FxTextStyle.bodyMedium(),
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              isDense: true,
                              labelStyle: FxTextStyle.bodyMedium(),
                              fillColor: controller.theme.primaryColor
                                  .withOpacity(0.4),
                              prefixIcon: Icon(
                                FeatherIcons.user,
                                color:
                                    controller.theme.colorScheme.onBackground,
                              ),
                              hintText: "Enter MRN",
                              enabledBorder: controller.outlineInputBorder,
                              focusedBorder: controller.outlineInputBorder,
                              border: controller.outlineInputBorder,
                              contentPadding: FxSpacing.all(16),
                              hintStyle: FxTextStyle.bodyMedium(),
                              isCollapsed: true),
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          controller: controller.mrnController,
                          validator: (value) => controller.validateMRN(value),
                          onSaved: (value) {
                            controller.mrnNumber.value = value!;
                          },
                          cursorColor: controller.theme.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
                FxSpacing.height(20),
                FxButton.block(
                  elevation: 0,
                  borderRadiusAll: Constant.buttonRadius.large,
                  onPressed: () {
                    controller.checkValidation();
                  },
                  splashColor:
                      controller.theme.colorScheme.onPrimary.withAlpha(30),
                  backgroundColor: controller.theme.primaryColor,
                  child: FxText.labelLarge(
                    "Sign In",
                    color: controller.theme.colorScheme.onPrimary,
                  ),
                ),
                FxSpacing.height(16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     FxButton.text(
                //       onPressed: () {
                //         controller.goToForgotPasswordScreen();
                //       },
                //       padding: FxSpacing.zero,
                //       splashColor:
                //           controller.theme.colorScheme.primary.withAlpha(40),
                //       child: FxText.bodySmall("Forgot your Password ?",
                //           color: controller.theme.primaryColor,
                //           decoration: TextDecoration.underline),
                //     ),
                //     FxButton.text(
                //       onPressed: () {
                //         Get.toNamed('/register');
                //       },
                //       padding: FxSpacing.zero,
                //       splashColor:
                //           controller.theme.colorScheme.primary.withAlpha(40),
                //       child: FxText.bodySmall(
                //         "Sign up",
                //         color: controller.theme.primaryColor,
                //         decoration: TextDecoration.underline,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
