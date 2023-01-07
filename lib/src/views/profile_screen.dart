import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutx/flutx.dart';
import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:get/get.dart';

import '../../theme/constant.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ThemeData theme;
  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = FxControllerStore.putOrFind(ProfileController());
    theme = AppTheme.reconSpotTheme;
  }

  Widget _buildSingleRow({String? title, IconData? icon}) {
    return InkWell(
      onTap: () async {
        if (title == 'Logout') {
          ArtDialogResponse response = await ArtSweetAlert.show(
              barrierDismissible: false,
              context: context,
              artDialogArgs: ArtDialogArgs(
                  denyButtonText: "No, go back",
                  denyButtonColor: Colors.red,
                  confirmButtonColor: Colors.green,
                  title: 'Logout',
                  text: "Are you sure, you want to logout of this app?",
                  confirmButtonText: "Yes, logout",
                  type: ArtSweetAlertType.warning));

          if (response.isTapConfirmButton) {
            authData.erase();
            appBox.erase();
            authData.write('isLogged', false);
            Get.back();
            Get.offAllNamed('/login');
          }
        }
        if (title == 'Share App') {
          //Share app link
          String link =
              'https://play.google.com/store/apps/details?id=tz.co.reaconspots';

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
            color: theme.primaryColor,
            child: Icon(
              icon,
              color: theme.colorScheme.onPrimary,
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
            color: theme.colorScheme.onBackground.withAlpha(160),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ProfileController>(
        controller: controller,
        builder: (controller) {
          return Theme(
            data: theme.copyWith(
                colorScheme:
                    theme.colorScheme.copyWith(secondary: theme.primaryColor)),
            child: Scaffold(
              body: Container(
                padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
                child: Column(
                  children: [
                    Container(
                      height: 2,
                      child: controller.showLoading
                          ? LinearProgressIndicator(
                              color: theme.colorScheme.primary,
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
        });
  }

  Widget _buildBody() {
    if (controller.uiLoading) {
      return Container(
          child: LoadingEffect.getSearchLoadingScreen(
        context,
      ));
    } else {
      return ListView(
        padding: FxSpacing.fromLTRB(20, FxSpacing.safeAreaTop(context), 20, 20),
        children: [
          Center(
            child: FxContainer(
              paddingAll: 0,
              borderRadiusAll: 24,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(Constant.containerRadius.large),
                ),
                child: Image(
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  image: AssetImage("assets/images/profile/avatar_place.png"),
                ),
              ),
            ),
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
                color: theme.colorScheme.primary,
                height: 6,
                width: 6,
                child: Container(),
              ),
              FxSpacing.width(6),
              FxText.bodyMedium(
                authData.read('phone'),
                color: theme.colorScheme.primary,
                muted: true,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          FxSpacing.height(24),
          FxText.bodyLarge(
            'General',
            color: theme.colorScheme.onBackground,
            fontWeight: 600,
            xMuted: true,
          ),
          FxSpacing.height(24),
          _buildSingleRow(title: 'Share App', icon: FeatherIcons.share),
          FxSpacing.height(8),
          Divider(),
          FxSpacing.height(8),
          _buildSingleRow(title: 'Contact Us', icon: FeatherIcons.info),
          FxSpacing.height(8),
          // Divider(),
          // FxSpacing.height(8),
          // _buildSingleRow(title: 'Password', icon: FeatherIcons.lock),
          // FxSpacing.height(8),
          // Divider(),
          // FxSpacing.height(8),
          // _buildSingleRow(title: 'Notifications', icon: FeatherIcons.bell),
          // FxSpacing.height(8),
          Divider(),
          FxSpacing.height(8),
          _buildSingleRow(title: 'Logout', icon: FeatherIcons.logOut),
        ],
      );
    }
  }
}
