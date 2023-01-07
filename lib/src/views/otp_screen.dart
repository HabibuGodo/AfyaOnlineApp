import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../componets/appSpinner.dart';
import '../controllers/otp_controller.dart';

class OTPScreen extends GetView<OTPController> {
  const OTPScreen({key});

  @override
  Widget build(BuildContext context) {
    //  Getx otp screen
    return Obx(
      () => controller.isLoading.value
          ? AppSpinner()
          : Scaffold(
              extendBodyBehindAppBar: true,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/icons/otp.gif",
                            height: 200,
                            width: 200,
                          ),
                          FxSpacing.height(16),
                          const Text(
                            'Phone Verification!',
                          ),
                          FxSpacing.height(8),
                          Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              'Enter OTP Code sent in +${controller.phone} now!',
                              textAlign: TextAlign.center),
                          FxSpacing.height(8),
                          _otpTextArea(context),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _otpTextArea(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PinCodeTextField(
        appContext: context,
        pastedTextStyle: TextStyle(
          color: Colors.green.shade600,
          fontWeight: FontWeight.bold,
        ),
        length: 4,
        obscureText: true,
        obscuringCharacter: '*',
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        validator: (v) {},
        pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 60,
            inactiveFillColor: Colors.white,
            inactiveColor: Colors.grey,
            activeFillColor: Colors.white,
            selectedColor: Colors.yellow,
            selectedFillColor: Colors.white),
        cursorColor: Colors.black54,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        // errorAnimationController: errorController,
        keyboardType: TextInputType.number,
        boxShadows: const [
          BoxShadow(
            offset: Offset(0, 1),
            color: Colors.black12,
            blurRadius: 10,
          )
        ],
        onCompleted: (codes) async {
          debugPrint("Completed");
          
          controller.otpinput.value = codes;
          controller.checkOTP();
        },
        // onTap: () {
        //   print("Pressed");
        // },
        onChanged: (value) {
          debugPrint(value);
          // setState(() {
          //   // invalidCode = "";
          //   // currentText = value;
          // });
        },
        beforeTextPaste: (text) {
          debugPrint("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
      ),
    );
  }
}
