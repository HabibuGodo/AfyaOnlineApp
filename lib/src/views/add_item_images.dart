import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutkit/src/services/base_service.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' as picture;
import 'package:image_pickers/image_pickers.dart';

import '../../../theme/constant.dart';
import '../controllers/add_item_controller.dart';

class AddItemImagesScreen extends GetView<AddItemController> {
  const AddItemImagesScreen({key});
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
              'Add Item Images',
              fontWeight: 700,
              color: controller.theme.colorScheme.primary,
            ),
            FxSpacing.height(30),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: OutlinedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_copy),
                            SizedBox(width: 10.0),
                            Flexible(
                              child: controller.imageList.isNotEmpty
                                  ? Text(
                                      "Change Images",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  : Text(
                                      "Select Images",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          _openImagePicker(Get.context!);
                        }),
                  ),
                  controller.listImagePaths.isEmpty
                      ? Container()
                      : GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.listImagePaths.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20.0,
                                  crossAxisSpacing: 10.0,
                                  childAspectRatio: 1.0),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
//                        ImagePickers.previewImage(_listImagePaths[index].path);

//                      List<String> paths = [];
//                        _listImagePaths.forEach((media){
//                          paths.add(media.path);
//                        });
//
//                        ImagePickers.previewImages(paths,index);

                                ImagePickers.previewImagesByMedia(
                                    controller.listImagePaths, index);
                              },
                              child: Image.file(
                                File(
                                  controller.listImagePaths[index].path!,
                                ),
                                fit: BoxFit.cover,
                              ),
                            );
                          }),
                ],
              ),

              //  GridView.count(
              //   crossAxisCount: 2,
              //   shrinkWrap: true,
              //   physics: const ScrollPhysics(),
              //   children: List.generate(4, (index) {
              //     return index == 0
              //         ? Card(
              //             color: Colors.white,
              //             child: Container(
              //               width: double.infinity,
              //               child: controller.myPhoto1.value.isNotEmpty
              //                   ? Image.file(
              //                       File(controller.myPhoto1.value),
              //                       fit: BoxFit.cover,
              //                     )

              //                   // Image.network(
              //                   //     "${imageURL}${controller.myPhoto1.value}",
              //                   //     width:
              //                   //         MediaQuery.of(Get.context!).size.width,
              //                   //     fit: BoxFit.cover,
              //                   //   )
              //                   : Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         //Text(index.toString()),

              //                         const Text("Image 1 "),

              //                         GestureDetector(
              //                           onTap: () {
              //                             _openImagePicker(Get.context!, "1");
              //                           },
              //                           child: Icon(
              //                             Icons.add_photo_alternate_rounded,
              //                             size: 50,
              //                             color: Theme.of(Get.context!)
              //                                 .primaryColor,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //             ),
              //           )
              //         : index == 1
              //             ? Card(
              //                 color: Colors.white,
              //                 child: Container(
              //                   child: controller.myPhoto2.value.isNotEmpty
              //                       ? Image.file(
              //                           File(controller.myPhoto2.value),
              //                           fit: BoxFit.cover,
              //                         )

              //                       // Image.network(
              //                       //     "${imageURL}${controller.myPhoto2.value}",
              //                       //     width: MediaQuery.of(Get.context!)
              //                       //         .size
              //                       //         .width,
              //                       //     fit: BoxFit.cover,
              //                       //   )
              //                       : Column(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.center,
              //                           children: [
              //                             //Text(index.toString()),

              //                             const Text("Image 2 "),

              //                             GestureDetector(
              //                               onTap: () {
              //                                 _openImagePicker(
              //                                     Get.context!, "2");
              //                               },
              //                               child: Icon(
              //                                 Icons.add_photo_alternate_rounded,
              //                                 size: 50,
              //                                 color: Theme.of(Get.context!)
              //                                     .primaryColor,
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                 ),
              //               )
              //             : index == 2
              //                 ? Card(
              //                     color: Colors.white,
              //                     child: Container(
              //                       child: controller.myPhoto3.value.isNotEmpty
              //                           ? Image.file(
              //                               File(controller.myPhoto3.value),
              //                               fit: BoxFit.cover,
              //                             )

              //                           // Image.network(
              //                           //     "${imageURL}${controller.myPhoto3.value}",
              //                           //     width: MediaQuery.of(Get.context!)
              //                           //         .size
              //                           //         .width,
              //                           //     fit: BoxFit.cover,
              //                           //   )
              //                           : Column(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.center,
              //                               children: [
              //                                 //Text(index.toString()),

              //                                 const Text("Image 3 "),

              //                                 GestureDetector(
              //                                   onTap: () {
              //                                     _openImagePicker(
              //                                         Get.context!, "3");
              //                                   },
              //                                   child: Icon(
              //                                     Icons
              //                                         .add_photo_alternate_rounded,
              //                                     size: 50,
              //                                     color: Theme.of(Get.context!)
              //                                         .primaryColor,
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                     ),
              //                   )
              //                 : Card(
              //                     color: Colors.white,
              //                     child: Container(
              //                       child: controller.myPhoto4.value.isNotEmpty
              //                           ? Stack(
              //                               children: [
              //                                 Image.file(
              //                                   File(controller.myPhoto4.value),
              //                                   fit: BoxFit.cover,
              //                                 ),
              //                                 GestureDetector(
              //                                   onTap: () {
              //                                     _openImagePicker(
              //                                         Get.context!, "1");
              //                                   },
              //                                   child: Icon(
              //                                     Icons
              //                                         .add_photo_alternate_rounded,
              //                                     size: 50,
              //                                     color: Theme.of(Get.context!)
              //                                         .primaryColor,
              //                                   ),
              //                                 ),
              //                               ],
              //                             )

              //                           // Image.network(
              //                           //     "${imageURL}${controller.myPhoto4.value}",
              //                           //     width: MediaQuery.of(Get.context!)
              //                           //         .size
              //                           //         .width,
              //                           //     fit: BoxFit.cover,
              //                           //   )
              //                           : Column(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.center,
              //                               children: [
              //                                 //Text(index.toString()),

              //                                 const Text("Image 4 "),

              //                                 GestureDetector(
              //                                   onTap: () {
              //                                     _openImagePicker(
              //                                         Get.context!, "4");
              //                                   },
              //                                   child: Icon(
              //                                     Icons
              //                                         .add_photo_alternate_rounded,
              //                                     size: 50,
              //                                     color: Theme.of(Get.context!)
              //                                         .primaryColor,
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                     ),
              //                   );
              //   }),
              // ),
            ),
            FxSpacing.height(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxButton.medium(
                  elevation: 0,
                  borderRadiusAll: Constant.buttonRadius.large,
                  onPressed: () {
                    Get.back();
                  },
                  splashColor:
                      controller.theme.colorScheme.onPrimary.withAlpha(30),
                  backgroundColor: controller.theme.colorScheme.primary,
                  child: FxText.labelLarge(
                    "Back",
                    color: controller.theme.colorScheme.onPrimary,
                  ),
                ),
                FxButton.medium(
                  elevation: 0,
                  borderRadiusAll: Constant.buttonRadius.large,
                  onPressed: () {
                    controller.postProduct();
                  },
                  splashColor:
                      controller.theme.colorScheme.onPrimary.withAlpha(30),
                  backgroundColor: controller.theme.colorScheme.primary,
                  child: FxText.labelLarge(
                    "Finish",
                    color: controller.theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            FxSpacing.height(16),
          ],
        ),
      ),
    );
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            height: 210.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'Pick an Image',
                  style: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Theme.of(Get.context!).primaryColor),
                  child: Text(
                    'Choose Images',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    // _getImage(context, picture.ImageSource.gallery);
                    controller.selectImages('gallery');

                    // controller.uploadPhoto(
                    //     picture.ImageSource.gallery, imgNumber);
                  },
                ),
                // TextButton(
                //   style: TextButton.styleFrom(
                //       primary: Theme.of(Get.context!).primaryColor),
                //   child: Text('Use Camera'),
                //   onPressed: () {
                //     // _getImage(context, picture.ImageSource.camera);
                //     // controller.uploadPhoto(ImageSource.gallery);
                //     controller.selectImages('camera');
                //     // controller.uploadPhoto(
                //     //     picture.ImageSource.camera, imgNumber);
                //   },
                // ),
              ],
            ),
          );
        });
  }
}
