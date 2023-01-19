import 'dart:developer';

import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/src/models/user_model.dart';
import 'package:flutkit/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../controllers/chats/user_to_add_controller.dart';

class UserListToAddScreen extends GetView<UserToAddController> {
  const UserListToAddScreen({Key? key});

  List<Widget> _buildUserList() {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    for (UserModel user in controller.allUserNotInGroup) {
      list.add(_buildSingleUser(user));
      list.add(Divider());
    }
    return list;
  }

  Widget _buildSingleUser(UserModel user) {
    //return user with checkbox
    return Container(
      margin: FxSpacing.top(16),
      child: Row(
        children: [
          Checkbox(
            value: user.isUserSelected,
            onChanged: (value) {
              user.isUserSelected = value!;
              controller.update();
              if (user.isUserSelected == true) {
                controller.selectedIds.add(user.id!);
              }
              if (user.isUserSelected == false) {
                controller.selectedIds.remove(user.id);
              }
            },
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      user.isUserSelected = !user.isUserSelected;
                      controller.update();
                      if (user.isUserSelected == true) {
                        controller.selectedIds.add(user.id!);
                      }
                      if (user.isUserSelected == false) {
                        controller.selectedIds.remove(user.id);
                      }
                    },
                    child: FxText.b1(user.name!)),
              ],
            ),
          ),
          FxSpacing.width(16),
        ],
      ),
    );

    // return
    // FxContainer(
    //   onTap: () {
    //     Get.toNamed('/single_chat', arguments: {
    //       'otherUserId': user.id,
    //       'receiverName': user.name,
    //       'checkRoute': "single"
    //     });
    //   },
    //   margin: FxSpacing.bottom(16),
    //   paddingAll: 16,
    //   borderRadiusAll: Constant.containerRadius.medium,
    //   child: Row(
    //     children: [
    //       Icon(FeatherIcons.user),
    //       FxSpacing.width(16),
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             FxText.bodyMedium(
    //               user.name!.capitalizeFirst!,
    //               fontWeight: 600,
    //               fontSize: 15,
    //             ),
    //             // FxSpacing.height(4),
    //             // FxText.bodySmall(
    //             //   chat.chat,
    //             //   xMuted: chat.replied,
    //             //   muted: !chat.replied,
    //             //   fontWeight: chat.replied ? 400 : 600,
    //             // ),
    //           ],
    //         ),
    //       ),
    //       FxSpacing.width(8),
    //     ],
    //   ),
    // );
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
            body: Container(
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
                                "Select User to Add",
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
            // floating action button
            floatingActionButton: controller.selectedIds.isEmpty
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      //call add function
                      // log(controller.groupId.toString());
                      // log(controller.selectedIds.toString());
                      controller.saveGroupMember(
                          controller.groupId, controller.selectedIds);
                    },
                    backgroundColor: controller.theme.colorScheme.primary,
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: controller.theme.colorScheme.onPrimary),
                    )),
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
