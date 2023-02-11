import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/src/controllers/chats/chat_controller.dart';
import 'package:flutkit/src/models/group_model.dart';
import 'package:flutkit/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../services/local_storage.dart';

class GroupListScreen extends GetView<ChatController> {
  GroupListScreen({Key? key});

  List<Widget> _buildChatList() {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    for (GroupModel group in controller.groups) {
      list.add(_buildSingleChat(group));
    }
    return list;
  }

  Widget _buildSingleChat(GroupModel group) {
    return FxContainer(
      onTap: () {
        Get.toNamed('/group_chat', arguments: {
          'groupId': group.id,
          'groupName': group.groupName,
          'groupTokens': group.groupTokens,
          'checkRoute': "group"
        });
      },
      margin: FxSpacing.bottom(16),
      paddingAll: 16,
      borderRadiusAll: Constant.containerRadius.medium,
      child: Row(
        children: [
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyMedium(
                  group.groupName!,
                  fontWeight: 600,
                ),
                FxSpacing.height(4),
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
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              controller.getGroups();
            },
            child: Container(
              padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
              child: Column(
                children: [
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

          // floating action button
          floatingActionButton: authData.read("role") == 2
              ? Container()
              : FloatingActionButton(
                  onPressed: () {
                    Get.toNamed('/add_group');
                  },
                  backgroundColor: controller.theme.colorScheme.primary,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
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
            labelText: 'Search Group...',
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
              controller.filterGroupList(value);
            },
          ),
          FxSpacing.height(20),
          Column(
            children: _buildChatList(),
          ),
        ],
      );
    }
  }
}
