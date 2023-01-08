import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../theme/constant.dart';
import '../controllers/chat_controller.dart';

class AddGroupScreen extends GetView<ChatController> {
  const AddGroupScreen({key});

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
              'Group Info',
              fontWeight: 700,
              color: controller.theme.colorScheme.primary,
            ),
            FxSpacing.height(30),
            Form(
              key: controller.addGroupKey.value,
              child: Column(
                children: [
                  FxSpacing.height(20),
                  FxSpacing.height(20),
                  TextFormField(
                    style: FxTextStyle.bodyMedium(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        filled: true,
                        fillColor:
                            controller.theme.primaryColor.withOpacity(0.4),
                        hintText: "Group Name",
                        enabledBorder: controller.outlineInputBorder,
                        focusedBorder: controller.outlineInputBorder,
                        border: controller.outlineInputBorder,
                        contentPadding: FxSpacing.all(16),
                        hintStyle: FxTextStyle.bodyMedium(),
                        isCollapsed: true),
                    maxLines: 1,
                    controller: controller.groupNameTE,
                    validator: controller.validateGName,
                    cursorColor: controller.theme.colorScheme.onBackground,
                    onSaved: (value) {
                      controller.groupName.value = value.toString();
                    },
                  ),
                  FxSpacing.height(20),
                  // TextFormField(
                  //   style: FxTextStyle.bodyMedium(),
                  //   decoration: InputDecoration(
                  //       floatingLabelBehavior: FloatingLabelBehavior.never,
                  //       isDense: true,
                  //       filled: true,
                  //       fillColor:
                  //           controller.theme.primaryColor.withOpacity(0.4),
                  //       hintText: "Description",
                  //       enabledBorder: controller.outlineInputBorder,
                  //       focusedBorder: controller.outlineInputBorder,
                  //       border: controller.outlineInputBorder,
                  //       contentPadding: FxSpacing.all(16),
                  //       hintStyle: FxTextStyle.bodyMedium(),
                  //       isCollapsed: true),
                  //   maxLines: 5,
                  //   keyboardType: TextInputType.text,
                  //   controller: controller.descriptionTE,
                  //   cursorColor: controller.theme.colorScheme.onBackground,
                  //   validator: (value) => controller.validateDescription(value),
                  //   onSaved: (value) {
                  //     controller.description.value = value.toString();
                  //   },
                  // ),
                ],
              ),
            ),
            FxSpacing.height(20),
            // Column(
            //   children: [
            //     Container(
            //       height: 50,
            //       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //       child: OutlinedButton(
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Icon(Icons.file_copy),
            //               SizedBox(width: 10.0),
            //               Flexible(
            //                 child: controller.myPhoto1.value != ''
            //                     ? Text(
            //                         "Change Images",
            //                         style: TextStyle(
            //                           color: Colors.grey[600],
            //                         ),
            //                       )
            //                     : Text(
            //                         "Select Images",
            //                         style: TextStyle(
            //                           color: Colors.grey[600],
            //                         ),
            //                       ),
            //               ),
            //             ],
            //           ),
            //           onPressed: () {
            //             _openImagePicker(Get.context!);
            //           }),
            //     ),
            //     controller.listImagePaths.isEmpty
            //         ? Container()
            //         : GridView.builder(
            //             physics: NeverScrollableScrollPhysics(),
            //             itemCount: controller.listImagePaths.length,
            //             shrinkWrap: true,
            //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //                 crossAxisCount: 2,
            //                 mainAxisSpacing: 20.0,
            //                 crossAxisSpacing: 10.0,
            //                 childAspectRatio: 1.0),
            //             itemBuilder: (BuildContext context, int index) {
            //               return GestureDetector(
            //                 onTap: () {
            //                   ImagePickers.previewImagesByMedia(
            //                       controller.listImagePaths, index);
            //                 },
            //                 child: Image.file(
            //                   File(
            //                     controller.listImagePaths[index].path!,
            //                   ),
            //                   fit: BoxFit.cover,
            //                 ),
            //               );
            //             }),
            //   ],
            // ),
            // FxSpacing.height(20),
            FxButton.block(
              elevation: 0,
              borderRadiusAll: Constant.buttonRadius.large,
              onPressed: () {
                controller.checkValidation1();
                if (controller.validated1.value == true) {
                  // Get.toNamed('/add_item_location');
                  // controller.postPhoneNumber();
                  controller.validated1.value = true;
                  controller.createGroup();
                }
              },
              splashColor: controller.theme.colorScheme.onPrimary.withAlpha(30),
              backgroundColor: controller.theme.colorScheme.primary,
              child: FxText.labelLarge(
                "Create",
                color: controller.theme.colorScheme.onPrimary,
              ),
            ),
            FxSpacing.height(16),
          ],
        ),
      ),
    );
  }

  // void _openImagePicker(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //           color: Colors.white,
  //           height: 210.0,
  //           padding: EdgeInsets.all(10.0),
  //           child: Column(
  //             children: [
  //               Text(
  //                 'Pick an Image',
  //                 style: TextStyle(
  //                     color: Colors.grey[600], fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 height: 10.0,
  //               ),
  //               TextButton(
  //                 style: TextButton.styleFrom(
  //                     primary: Theme.of(Get.context!).primaryColor),
  //                 child: Text(
  //                   'Choose Images',
  //                   style: TextStyle(fontSize: 20),
  //                 ),
  //                 onPressed: () {
  //                   // _getImage(context, picture.ImageSource.gallery);
  //                   controller.selectImages('gallery');

  //                   // controller.uploadPhoto(
  //                   //     picture.ImageSource.gallery, imgNumber);
  //                 },
  //               ),
  //               // TextButton(
  //               //   style: TextButton.styleFrom(
  //               //       primary: Theme.of(Get.context!).primaryColor),
  //               //   child: Text('Use Camera'),
  //               //   onPressed: () {
  //               //     // _getImage(context, picture.ImageSource.camera);
  //               //     // controller.uploadPhoto(ImageSource.gallery);
  //               //     controller.selectImages('camera');
  //               //     // controller.uploadPhoto(
  //               //     //     picture.ImageSource.camera, imgNumber);
  //               //   },
  //               // ),
  //             ],
  //           ),
  //         );
  //       });
  // }
}
