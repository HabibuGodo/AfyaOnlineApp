import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutkit/src/controllers/global.dart';
import 'package:flutkit/src/services/base_service.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutx/flutx.dart';
import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart' as picture;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../theme/constant.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

  Widget _buildSingleRow({String? title, IconData? icon}) {
    return InkWell(
      onTap: () async {
        if (title == 'Logout') {
          ArtDialogResponse response = await ArtSweetAlert.show(
              barrierDismissible: false,
              context: Get.context!,
              artDialogArgs: ArtDialogArgs(
                  denyButtonText: "No, go back",
                  denyButtonColor: Colors.red,
                  confirmButtonColor: controller.theme.colorScheme.primary,
                  title: 'Logout',
                  text: "Are you sure, you want to logout of this app?",
                  confirmButtonText: "Yes, logout",
                  type: ArtSweetAlertType.warning));

          if (response.isTapConfirmButton) {
            authData.erase();
            appBox.erase();
            authData.write('isLogged', false);
            IsolateNameServer.removePortNameMapping('downloader_send_port');
            Get.back();
            Get.offAllNamed('/login');
          }
        }
        if (title == 'Share App') {
          //Share app link
          String link =
              'https://play.google.com/store/apps/details?id=afya.ho.online';

          await FlutterShare.share(
            title: 'ReconSpots',
            text: 'Check out ReconSpots App on the Google Play Store!',
            linkUrl: link,
            chooserTitle: 'Share ReconSpots App',
          );
        }
        if (title == 'Contact Us') {
          Get.toNamed("/contact-us");
        }
      },
      child: Row(
        children: [
          FxContainer(
            paddingAll: 8,
            borderRadiusAll: Constant.containerRadius.small,
            color: controller.theme.primaryColor,
            child: Icon(
              icon,
              color: controller.theme.colorScheme.onPrimary,
              size: 20,
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: FxText.bodySmall(
              title!,
              letterSpacing: 0.5,
            ),
          ),
          FxSpacing.width(16),
          Icon(
            Icons.keyboard_arrow_right,
            color: controller.theme.colorScheme.onBackground.withAlpha(160),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: controller.theme.copyWith(
          colorScheme: controller.theme.colorScheme
              .copyWith(secondary: controller.theme.primaryColor)),
      child: Scaffold(
        body: Container(
          padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
          child: Column(
            children: [
              Container(
                height: 2,
                child: controller.showLoading
                    ? LinearProgressIndicator(
                        color: controller.theme.colorScheme.primary,
                        minHeight: 2,
                      )
                    : Container(
                        height: 2,
                      ),
              ),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.uiLoading) {
      return Container(
          child: LoadingEffect.getSearchLoadingScreen(
        Get.context!,
      ));
    } else {
      return Obx(
        () => ListView(
          padding: FxSpacing.fromLTRB(
              20, FxSpacing.safeAreaTop(Get.context!), 20, 20),
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                          imageUrl:
                              imageURL + Global.profileuRl.value.toString(),
                          imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          placeholder: (context, url) =>
                              //local git
                              Image.asset(
                                "assets/images/profile/loading.gif",
                                fit: BoxFit.cover,
                                scale: 1,
                              )),
                    ),
                  ),
                ),
                Positioned(
                  top: 65,
                  left: MediaQuery.of(Get.context!).size.width / 2,
                  child: GestureDetector(
                      onTap: () {
                        _openImagePicker(Get.context!);
                      },
                      child: Icon(
                        Icons.add_a_photo,
                        color: controller.theme.colorScheme.primary,
                        size: 40,
                      )),
                ),
              ],
            ),
            FxSpacing.height(24),
            FxText.titleMedium(
              authData.read('name').toString().capitalize!,
              textAlign: TextAlign.center,
              fontWeight: 600,
              letterSpacing: 0.8,
            ),

            FxSpacing.height(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FxContainer.rounded(
                  color: controller.theme.colorScheme.primary,
                  height: 6,
                  width: 6,
                  child: Container(),
                ),
                FxSpacing.width(6),
                FxText.bodyMedium(
                  authData.read('phone'),
                  color: controller.theme.colorScheme.primary,
                  muted: true,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            FxSpacing.height(4),
            mrnWidget(),
            FxSpacing.height(24),
            FxText.bodyLarge(
              'General',
              color: controller.theme.colorScheme.onBackground,
              fontWeight: 600,
              xMuted: true,
            ),
            // FxSpacing.height(24),
            // _buildSingleRow(title: 'Edit Profile', icon: FeatherIcons.edit),
            // FxSpacing.height(8),
            // Divider(),
            // FxSpacing.height(8),
            // _buildSingleRow(title: 'Change Password', icon: FeatherIcons.edit2),
            // FxSpacing.height(8),
            // Divider(),
            // FxSpacing.height(8),
            // _buildSingleRow(title: 'Saved Posts', icon: FeatherIcons.save),
            // FxSpacing.height(8),
            // Divider(),
            // FxSpacing.height(8),
            // _buildSingleRow(title: 'Notifications', icon: FeatherIcons.bell),
            // FxSpacing.height(8),
            Divider(),
            FxSpacing.height(8),
            _buildSingleRow(title: 'Logout', icon: FeatherIcons.logOut),
            FxSpacing.height(8),
            Divider(),
          ],
        ),
      );
    }
  }

  Widget mrnWidget() {
    return Align(
      alignment: Alignment.center,
      child: FxContainer(
        padding: FxSpacing.fromLTRB(6, 4, 12, 4),
        borderRadiusAll: Constant.containerRadius.large,
        color: controller.theme.colorScheme.primaryContainer,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: controller.theme.colorScheme.onPrimaryContainer,
              size: 16,
            ),
            FxSpacing.width(8),
            FxText.bodySmall(
              "${authData.read('mrn')}",
              color: controller.theme.colorScheme.onPrimaryContainer,
              fontWeight: 600,
            ),
          ],
        ),
      ),
    );
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
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
                  style: TextButton.styleFrom(primary: Colors.orange[300]),
                  child: Text('Use Camera'),
                  onPressed: () {
                    // _getImage(context, picture.ImageSource.camera);
                    // controller.uploadPhoto(ImageSource.gallery);
                    controller.uploadPhoto(picture.ImageSource.camera);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.orange[300]),
                  child: Text('Use Gallery'),
                  onPressed: () {
                    // _getImage(context, picture.ImageSource.gallery);
                    controller.uploadPhoto(picture.ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }
}
