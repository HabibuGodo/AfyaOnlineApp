import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/src/controllers/chats/chat_controller.dart';
import 'package:flutkit/src/controllers/global.dart';
import 'package:flutkit/src/models/user_model.dart';
import 'package:flutkit/src/services/base_service.dart';
import 'package:flutkit/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

class UserListScreen extends GetView<ChatController> {
  const UserListScreen({Key? key});

  List<Widget> _buildUserList() {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    for (UserModel user in controller.allUser) {
      list.add(_buildSingleUser(user));
    }
    return list;
  }

  Widget _buildSingleUser(UserModel user) {
    return FxContainer(
      onTap: () {
        Get.toNamed('/single_chat', arguments: {
          'otherUserId': user.id,
          'receiverName': user.name,
          'receiverProfile': user.profileImage,
          'checkRoute': "single"
        });
      },
      margin: FxSpacing.bottom(16),
      paddingAll: 16,
      borderRadiusAll: Constant.containerRadius.medium,
      child: Row(
        children: [
          Center(
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                    imageUrl: imageURL + user.profileImage.toString(),
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                    errorWidget: (context, url, error) =>
                        Icon(FeatherIcons.user),
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
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyMedium(
                  user.name!.capitalizeFirst!,
                  fontWeight: 600,
                  fontSize: 15,
                ),
                // FxSpacing.height(4),
                // FxText.bodySmall(
                //   chat.chat,
                //   xMuted: chat.replied,
                //   muted: !chat.replied,
                //   fontWeight: chat.replied ? 400 : 600,
                // ),
              ],
            ),
          ),
          FxSpacing.width(8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Theme(
        data: controller.theme.copyWith(
            colorScheme: controller.theme.colorScheme
                .copyWith(secondary: controller.theme.primaryColor)),
        child: SafeArea(
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                controller.getUserList();
              },
              child: Container(
                padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
                child: Column(
                  children: [
                    FxContainer(
                      color: controller.theme.scaffoldBackgroundColor,
                      child: Row(
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: controller.theme.colorScheme.onBackground,
                            ),
                            onTap: () {
                              // Navigator.pop(context);
                              Get.back();
                            },
                          ),
                          FxSpacing.width(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.bodyMedium(
                                  "Users List",
                                  fontWeight: 900,
                                ),
                              ],
                            ),
                          ),
                          FxSpacing.width(20),
                        ],
                      ),
                    ),
                    Container(
                      height: 2,
                      child: controller.showLoading.value
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
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.uiLoading.value) {
      return Container(
          child: LoadingEffect.getSearchLoadingScreen(
        Get.context!,
      ));
    } else {
      return ListView(
        padding: FxSpacing.x(20),
        children: [
          FxSpacing.height(16),
          FxTextField(
            textFieldStyle: FxTextFieldStyle.outlined,
            labelText: 'Search User...',
            focusedBorderColor: controller.theme.colorScheme.onPrimary,
            enabledBorderRadius: Constant.containerRadius.medium,
            focusedBorderRadius: Constant.containerRadius.medium,
            cursorColor: controller.theme.colorScheme.onPrimary,
            labelStyle: FxTextStyle.bodySmall(
                color: controller.theme.colorScheme.onPrimary, xMuted: false),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: controller.theme.colorScheme.primary.withOpacity(0.5),
            suffixIcon: Icon(
              FeatherIcons.search,
              color: controller.theme.colorScheme.onPrimary,
              size: 20,
            ),
            onChanged: (value) {
              controller.filterUsersList(value);
            },
          ),
          FxSpacing.height(20),
          Column(
            children: _buildUserList(),
          ),
        ],
      );
    }
  }
}
