import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
import '../models/chat.dart';

class ChatScreen extends GetView<ChatController> {
  ChatScreen({Key? key});

  List<Widget> _buildChatList() {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    for (Chat chat in controller.chats) {
      list.add(_buildSingleChat(chat));
    }
    return list;
  }

  Widget _buildSingleChat(Chat chat) {
    return FxContainer(
      onTap: () {
        Get.toNamed('/single_chat', arguments: {'chat': chat});
      },
      margin: FxSpacing.bottom(16),
      paddingAll: 16,
      borderRadiusAll: Constant.containerRadius.medium,
      child: Row(
        children: [
          Stack(
            children: [
              FxContainer.rounded(
                paddingAll: 0,
                child: Image(
                  height: 54,
                  width: 54,
                  image: AssetImage(chat.image),
                ),
              ),
              Positioned(
                right: 4,
                bottom: 2,
                child: FxContainer.rounded(
                  paddingAll: 5,
                  child: Container(),
                  color: Colors.green,
                ),
              )
            ],
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyMedium(
                  chat.name,
                  fontWeight: 600,
                ),
                FxSpacing.height(4),
                FxText.bodySmall(
                  chat.chat,
                  xMuted: chat.replied,
                  muted: !chat.replied,
                  fontWeight: chat.replied ? 400 : 600,
                ),
              ],
            ),
          ),
          FxSpacing.width(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FxText.bodySmall(
                chat.time,
                fontSize: 10,
                color: controller.theme.colorScheme.onBackground,
                xMuted: true,
              ),
              chat.replied
                  ? FxSpacing.height(16)
                  : FxContainer.rounded(
                      paddingAll: 6,
                      color: controller.theme.colorScheme.primary,
                      child: FxText.bodySmall(
                        chat.messages,
                        fontSize: 10,
                        color: controller.theme.colorScheme.onPrimary,
                      ),
                    ),
            ],
          ),
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
          body: Container(
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
          Center(
            child: FxText.bodyLarge(
              'Chats',
              fontWeight: 700,
            ),
          ),
          FxSpacing.height(16),
          FxTextField(
            textFieldStyle: FxTextFieldStyle.outlined,
            labelText: 'Search your agent...',
            focusedBorderColor: controller.theme.colorScheme.primary,
            enabledBorderRadius: Constant.containerRadius.medium,
            focusedBorderRadius: Constant.containerRadius.medium,
            cursorColor: controller.theme.colorScheme.primary,
            labelStyle: FxTextStyle.bodySmall(
                color: controller.theme.colorScheme.onPrimary, xMuted: true),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: controller.theme.primaryColor,
            suffixIcon: Icon(
              FeatherIcons.search,
              color: controller.theme.colorScheme.primary,
              size: 20,
            ),
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
