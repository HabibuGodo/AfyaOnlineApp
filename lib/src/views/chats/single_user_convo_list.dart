import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/src/controllers/chat_controller.dart';
import 'package:flutkit/src/models/conversationModel.dart';
import 'package:flutkit/src/models/group_model.dart';
import 'package:flutkit/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../services/local_storage.dart';

class SingleUserConvoListScreen extends GetView<ChatController> {
  SingleUserConvoListScreen({Key? key});

  List<Widget> _buildChatList() {
    List<Widget> list = [];
    list.add(FxSpacing.width(16));
    if (controller.allConvo.length == 0) {
      list.add(Container(
        margin: FxSpacing.top(200),
        child: Center(
          child: FxText.sh1(
            "No any conversation",
            color: controller.theme.colorScheme.onBackground,
            textAlign: TextAlign.center,
          ),
        ),
      ));
    } else {
      for (CoversatationModel convo in controller.allConvo) {
        list.add(_buildSingleChat(convo));
      }
    }
    return list;
  }

  Widget _buildSingleChat(CoversatationModel convo) {
    return FxContainer(
      onTap: () {
        Get.toNamed('/single_chat', arguments: {
          'receiverId': convo.receiverId,
          'receiverName': convo.receiverName.toString(),
          'checkRoute': "single"
        });
      },
      margin: FxSpacing.bottom(16),
      paddingAll: 16,
      borderRadiusAll: Constant.containerRadius.medium,
      child: Row(
        children: [
          Icon(FeatherIcons.user),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyMedium(
                  convo.receiverName!.toString(),
                  fontWeight: 600,
                  fontSize: 15,
                ),
              ],
            ),
          ),
          FxSpacing.width(6),
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
              controller.getConvoList();
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
                    Get.toNamed('/user_list');
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
            children: _buildChatList(),
          ),
        ],
      );
    }
  }
}
