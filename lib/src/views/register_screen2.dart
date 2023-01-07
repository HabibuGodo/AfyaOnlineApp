// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutx/flutx.dart';
// import 'package:flutkit/images.dart';
// import 'package:flutkit/theme/app_theme.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart' as picture;
// import 'package:decorated_dropdownbutton/decorated_dropdownbutton.dart';

// import '../../../theme/constant.dart';
// import '../controllers/register_controller.dart';

// class Register2Screen extends GetView<RegisterController> {
//   const Register2Screen({key});
//   @override
//   Widget build(BuildContext context) {
//     return _buildBody();
//   }

//   Widget _buildBody() {
//     return Obx(
//       () => Scaffold(
//         body: ListView(
//           padding: FxSpacing.fromLTRB(
//               20, FxSpacing.safeAreaTop(Get.context!) + 36, 20, 20),
//           children: [
//             FxText.displaySmall(
//               'Almost There! \nFill to Get Started',
//               fontWeight: 700,
//               color: controller.theme.colorScheme.primary,
//             ),
//             FxSpacing.height(40),
//             FxSpacing.height(40),
//             Form(
//               key: controller.register2.value,
//               child: Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       // controller.uploadPhoto(ImageSource.gallery);
//                       _openImagePicker(Get.context!);
//                     },
//                     child: CircleAvatar(
//                       radius: 60,
//                       // backgroundColor: appColor,
//                       child: ClipOval(
//                         child: SizedBox(
//                             width: 120,
//                             height: 120,
//                             child: const Icon(
//                               Icons.add_a_photo,
//                               color: Colors.white,
//                             )

//                             // controller.myPhoto.value.isEmpty
//                             //     ? const Icon(
//                             //         Icons.add_a_photo,
//                             //         color: Colors.white,
//                             //       )
//                             //     : Image.file(
//                             //         File(controller.myPhoto.value),
//                             //         fit: BoxFit.cover,
//                             //       ),
//                             ),
//                       ),
//                     ),
//                   ),
//                   FxSpacing.height(20),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: controller.theme.primaryColor,
//                       border: Border.all(
//                         width: 1,
//                         color: Colors.white,
//                       ),
//                       borderRadius: BorderRadius.circular(18),
//                     ),
//                     child: DropdownButton<String>(
//                       dropdownColor: Colors.white,
//                       isExpanded: true,
//                       value: controller.idType.value,
//                       icon: const Icon(Icons.arrow_drop_down),
//                       onChanged: (String? newValue) {
//                         controller.idType.value = newValue!;
//                       },
//                       items: <String>['NIDA', 'Voter', 'Passport', 'License']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Container(
//                             margin: EdgeInsets.symmetric(horizontal: 20),
//                             child: Text(
//                               value,
//                               style: FxTextStyle.bodyMedium(),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   FxSpacing.height(20),
//                   TextFormField(
//                     style: FxTextStyle.bodyMedium(),
//                     decoration: InputDecoration(
//                         floatingLabelBehavior: FloatingLabelBehavior.never,
//                         filled: true,
//                         isDense: true,
//                         fillColor:
//                             controller.theme.primaryColor,
//                         // prefixIcon: Icon(
//                         //   FeatherIcons.di,
//                         //   color: theme.colorScheme.onBackground,
//                         // ),
//                         hintText: "Id Number",
//                         enabledBorder: controller.outlineInputBorder,
//                         focusedBorder: controller.outlineInputBorder,
//                         border: controller.outlineInputBorder,
//                         contentPadding: FxSpacing.all(16),
//                         hintStyle: FxTextStyle.bodyMedium(),
//                         isCollapsed: true),
//                     maxLines: 1,
//                     controller: controller.nameTE,
//                     validator: controller.validateName,
//                     cursorColor: controller.theme.colorScheme.onBackground,
//                   ),
//                   FxSpacing.height(20),
//                   // TextFormField(
//                   //   style: FxTextStyle.bodyMedium(),
//                   //   decoration: InputDecoration(
//                   //       floatingLabelBehavior: FloatingLabelBehavior.never,
//                   //       filled: true,
//                   //       isDense: true,
//                   //       fillColor: theme.primaryColor,
//                   //       prefixIcon: Icon(
//                   //         FeatherIcons.mail,
//                   //         color: theme.colorScheme.onBackground,
//                   //       ),
//                   //       hintText: "Email Address",
//                   //       enabledBorder: outlineInputBorder,
//                   //       focusedBorder: outlineInputBorder,
//                   //       border: outlineInputBorder,
//                   //       contentPadding: FxSpacing.all(16),
//                   //       hintStyle: FxTextStyle.bodyMedium(),
//                   //       isCollapsed: true),
//                   //   maxLines: 1,
//                   //   controller: controller.emailTE,
//                   //   validator: controller.validateEmail,
//                   //   cursorColor: theme.colorScheme.onBackground,
//                   // ),
//                   // FxSpacing.height(20),
//                   // TextFormField(
//                   //   style: FxTextStyle.bodyMedium(),
//                   //   decoration: InputDecoration(
//                   //       floatingLabelBehavior: FloatingLabelBehavior.never,
//                   //       filled: true,
//                   //       isDense: true,
//                   //       fillColor: theme.primaryColor,
//                   //       prefixIcon: Icon(
//                   //         FeatherIcons.lock,
//                   //         color: theme.colorScheme.onBackground,
//                   //       ),
//                   //       hintText: "Password",
//                   //       enabledBorder: outlineInputBorder,
//                   //       focusedBorder: outlineInputBorder,
//                   //       border: outlineInputBorder,
//                   //       contentPadding: FxSpacing.all(16),
//                   //       hintStyle: FxTextStyle.bodyMedium(),
//                   //       isCollapsed: true),
//                   //   maxLines: 1,
//                   //   controller: controller.phoneNumber,
//                   //   validator: controller.validatePassword,
//                   //   cursorColor: theme.colorScheme.onBackground,
//                   // ),
//                 ],
//               ),
//             ),
//             FxSpacing.height(20),
//             FxButton.block(
//               elevation: 0,
//               borderRadiusAll: Constant.buttonRadius.large,
//               onPressed: () {
//                 Get.toNamed('/home');
//               },
//               splashColor: controller.theme.colorScheme.onPrimary.withAlpha(30),
//               backgroundColor: controller.theme.colorScheme.primary,
//               child: FxText.labelLarge(
//                 "Sign Up",
//                 color: controller.theme.colorScheme.onPrimary,
//               ),
//             ),
//             FxSpacing.height(20),
//             FxButton.block(
//               elevation: 0,
//               borderRadiusAll: Constant.buttonRadius.large,
//               onPressed: () {
//                 Get.toNamed('/register1');
//               },
//               splashColor: controller.theme.colorScheme.onPrimary.withAlpha(30),
//               backgroundColor: controller.theme.colorScheme.primary,
//               child: FxText.labelLarge(
//                 "Back",
//                 color: controller.theme.colorScheme.onPrimary,
//               ),
//             ),
//             FxSpacing.height(16),
//             Center(
//               child: FxButton.text(
//                 onPressed: () {
//                   Get.toNamed('/login');
//                 },
//                 padding: FxSpacing.zero,
//                 splashColor: controller.theme.colorScheme.primary.withAlpha(40),
//                 child: FxText.bodySmall("Already have an account?",
//                     color: controller.theme.colorScheme.primary,
//                     decoration: TextDecoration.underline),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _openImagePicker(BuildContext context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context) {
//           return Container(
//             color: Colors.white,
//             height: 210.0,
//             padding: EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 Text(
//                   'Pick an Image',
//                   style: TextStyle(
//                       color: Colors.grey[600], fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 TextButton(
//                   style: TextButton.styleFrom(primary: Colors.orange[300]),
//                   child: Text('Use Camera'),
//                   onPressed: () {
//                     // _getImage(context, picture.ImageSource.camera);
//                     // controller.uploadPhoto(ImageSource.gallery);
//                     controller.uploadPhoto(picture.ImageSource.camera);
//                   },
//                 ),
//                 TextButton(
//                   style: TextButton.styleFrom(primary: Colors.orange[300]),
//                   child: Text('Use Gallery'),
//                   onPressed: () {
//                     // _getImage(context, picture.ImageSource.gallery);
//                     controller.uploadPhoto(picture.ImageSource.gallery);
//                   },
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }
