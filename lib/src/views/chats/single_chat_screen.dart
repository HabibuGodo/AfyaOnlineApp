import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutkit/src/services/base_service.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutx/flutx.dart';
import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../theme/constant.dart';
import '../../controllers/chats/all_inside_chat_controller.dart';

import 'package:flutx/flutx.dart';

import '../../controllers/global.dart';
import '../../models/single_message_model.dart';

class SingleChatScreen extends GetView<AllInsideChatController> {
  const SingleChatScreen({key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Theme(
        data: controller.theme.copyWith(
            colorScheme: controller.theme.colorScheme
                .copyWith(secondary: controller.theme.primaryColor)),
        child: Padding(
          padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: controller.theme.colorScheme.primary,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                          imageUrl:
                              imageURL + controller.receiverProfile.toString(),
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
                  SizedBox(
                    width: 10,
                  ),
                  FxText.bodyMedium(
                    controller.receiverName ?? "",
                    color: controller.theme.colorScheme.primary,
                    fontWeight: 900,
                    fontSize: 15,
                  ),
                ],
              ),
              centerTitle: false,
            ),
            body: Column(
              children: [
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
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.7),
                    BlendMode.dstATop,
                  ),
                  image: AssetImage("assets/images/chat/background.jpg"),
                ),
              ),
              child: StreamBuilder(
                  stream: Global.fetchSinglesms(
                      controller.senderId, controller.receiverId),
                  builder: (context, snapshot) {
                    if (Global.singleChat.length == 0) {
                      return Container(
                        margin: FxSpacing.top(0),
                        child: Center(
                          child: FxText.sh1(
                            "No any message with ${controller.receiverName.toString()}",
                            color: controller.theme.colorScheme.onPrimary,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        child: ListView.builder(
                            controller: controller.scrollController.value,
                            shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: Global.singleChat.length,
                            itemBuilder: (context, index) {
                              DateTime tempDate =
                                  new DateFormat("dd-MM-yyyy hh:mm").parse(
                                      Global.singleChat[index].createdAt!);
                              // var date = DateTime.parse(messageText.createdAt!);
                              var now = DateTime.now();
                              var yesterday = now.subtract(Duration(days: 1));
                              var dateToShow = "";
                              if (tempDate.day == now.day &&
                                  tempDate.month == now.month &&
                                  tempDate.year == now.year) {
                                dateToShow =
                                    DateFormat.jm().format(tempDate).toString();
                              } else if (tempDate.day == yesterday.day &&
                                  tempDate.month == yesterday.month &&
                                  tempDate.year == yesterday.year) {
                                dateToShow = "Yesterday";
                              } else {
                                dateToShow = DateFormat.yMMMd()
                                    .format(tempDate)
                                    .toString();
                              }

                              if (Global.singleChat[index].senderId !=
                                  authData.read("user_id")) {
                                return Container(
                                  margin: FxSpacing.vertical(10.0),
                                  child: Padding(
                                    padding: FxSpacing.horizontal(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: FxContainer(
                                            color: Color(0xFFf5f5f7),
                                            margin: FxSpacing.right(140),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(
                                                    Constant.containerRadius
                                                        .medium),
                                                bottomRight: Radius.circular(
                                                    Constant.containerRadius
                                                        .medium),
                                                bottomLeft: Radius.circular(
                                                    Constant.containerRadius
                                                        .medium)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                FxText.bodySmall(
                                                  Global.singleChat[index]
                                                          .message ??
                                                      "",
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  xMuted: true,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: FxText.bodySmall(
                                                    dateToShow.toString(),
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    xMuted: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  margin: FxSpacing.vertical(10.0),
                                  child: Padding(
                                    padding: FxSpacing.horizontal(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: FxContainer(
                                            color: Color(0xFFe2ffc7),
                                            margin: FxSpacing.left(140),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    Constant.containerRadius
                                                        .medium),
                                                bottomRight: Radius.circular(
                                                    Constant.containerRadius
                                                        .medium),
                                                bottomLeft: Radius.circular(
                                                    Constant.containerRadius
                                                        .medium)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                FxText.bodySmall(
                                                  Global.singleChat[index]
                                                          .message ??
                                                      "",
                                                  // color: controller
                                                  //     .theme.colorScheme.onPrimary,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      FxText.bodySmall(
                                                        dateToShow.toString(),
                                                        fontSize: 10,
                                                        muted: true,
                                                        xMuted: true,
                                                        // color: controller.theme
                                                        //     .colorScheme.onPrimary,
                                                      ),
                                                      Global.singleChat[index]
                                                                  .receiverRead ==
                                                              0
                                                          ? Icon(
                                                              Icons.done_all,
                                                              size: 15,
                                                            )
                                                          : Icon(
                                                              Icons.done_all,
                                                              size: 15,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }),
                      );
                    }

                    // if (snapshot.hasError) {
                    //   // print("**** snapshot.error ****");
                    //   // print(snapshot.error);
                    //   if (snapshot.error.toString().contains("errno = 103")) {
                    //     return Container(
                    //       child: Center(child: Text("Server is down.")),
                    //     );
                    //   }
                    //   //print("snapshot.data");
                    //   //print(snapshot.data);
                    //   return Container(
                    //     child: Center(child: Text("No Connection!")),
                    //   );
                    // }
                    // return Container();
                  }),
            ),
          ),

          // controller.chat.length == 0 ? Spacer() : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: FxContainer(
              margin: EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 12.0, bottom: 0),
              paddingAll: 0,
              borderRadiusAll: Constant.containerRadius.medium,
              child: FxTextField(
                controller: controller.messageInputTE,
                focusedBorderColor: controller.theme.colorScheme.onPrimary,
                cursorColor: controller.theme.colorScheme.onPrimary,
                enabledBorderRadius: Constant.containerRadius.medium,
                focusedBorderRadius: Constant.containerRadius.medium,
                textFieldStyle: FxTextFieldStyle.outlined,
                labelText: 'Type Something ...',
                labelStyle: FxTextStyle.bodyMedium(
                    color: controller.theme.colorScheme.onPrimary,
                    xMuted: true),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor:
                    controller.theme.colorScheme.primary.withOpacity(0.5),
                suffixIcon: IconButton(
                    onPressed: () async {
                      if (controller.messageInput.value.length > 0) {
                        await controller.checkInternetThenSend();

                        Global.singleChat.add(SingleMessageModel(
                            id: Global.singleChat.length + 2,
                            conversationId: Global
                                .singleChat[Global.singleChat.length - 1]
                                .conversationId,
                            createdAt: DateTime.now().toString(),
                            message: controller.messageInput.value,
                            receiverId: controller.receiverId,
                            receiverRead: 0,
                            senderId: controller.senderId,
                            senderRead: 1,
                            status: '',
                            updatedAt: DateTime.now().toString()));
                        controller.messageInput.value = '';
                        controller.messageInputTE.clear();
                      } else {
                        Get.snackbar(
                            'Failed', 'You can not send an empty message',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                    icon: Icon(
                      FeatherIcons.send,
                      color: controller.theme.colorScheme.onPrimary,
                      size: 20,
                    )),
                onChanged: (value) {
                  if (value.length > 0) {
                    controller.messageInput.value = value;
                  } else {
                    controller.messageInput.value = '';
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
  // }s
}
