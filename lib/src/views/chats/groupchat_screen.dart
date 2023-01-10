import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutx/flutx.dart';
import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../theme/constant.dart';
import '../../controllers/all_inside_chat_controller.dart';

class GroupChatScreen extends GetView<AllInsideChatController> {
  const GroupChatScreen({key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Theme(
        data: controller.theme.copyWith(
            colorScheme: controller.theme.colorScheme
                .copyWith(secondary: controller.theme.primaryColor)),
        child: Scaffold(
          body: Padding(
            padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
            child: Column(
              children: [
                Container(
                  height: 5,
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
          margin: FxSpacing.top(16),
          child: LoadingEffect.getSearchLoadingScreen(
            Get.context!,
          ));
    } else {
      return Column(
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
                        controller.groupName,
                        fontWeight: 900,
                      ),
                    ],
                  ),
                ),
                FxSpacing.width(20),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: controller.fetchsms(controller.groupId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (controller.chat.length == 0) {
                      return Container(
                        margin: FxSpacing.top(200),
                        child: Center(
                          child: FxText.sh1(
                            "No any message",
                            color: controller.theme.colorScheme.onBackground,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.chat.length,
                          itemBuilder: (context, index) {
                            DateTime tempDate =
                                new DateFormat("dd-MM-yyyy hh:mm")
                                    .parse(controller.chat[index].createdAt!);
                            // var date = DateTime.parse(messageText.createdAt!);
                            var now = DateTime.now();
                            var yesterday = now.subtract(Duration(days: 1));
                            var dateToShow = "";
                            if (tempDate.day == now.day &&
                                tempDate.month == now.month &&
                                tempDate.year == now.year) {
                              dateToShow =
                                  "${DateFormat("hh:mm").format(tempDate).toString()}";
                            } else if (tempDate.day == yesterday.day &&
                                tempDate.month == yesterday.month &&
                                tempDate.year == yesterday.year) {
                              dateToShow = "Yesterday";
                            } else {
                              dateToShow =
                                  "${tempDate.day}/${tempDate.month}/${tempDate.year}";
                            }

                            if (controller.chat[index].senderId !=
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
                                          color: controller.theme.primaryColor,
                                          margin: FxSpacing.right(140),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(Constant
                                                  .containerRadius.medium),
                                              bottomRight: Radius.circular(
                                                  Constant
                                                      .containerRadius.medium),
                                              bottomLeft: Radius.circular(
                                                  Constant
                                                      .containerRadius.medium)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              FxText.bodySmall(
                                                controller.chat[index].message!,
                                                color: controller.theme
                                                    .colorScheme.onPrimary,
                                                xMuted: true,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: FxText.bodySmall(
                                                  dateToShow.toString(),
                                                  fontSize: 10,
                                                  color: controller.theme
                                                      .colorScheme.onPrimary,
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
                                          color: controller
                                              .theme.colorScheme.primary,
                                          margin: FxSpacing.left(140),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(Constant
                                                  .containerRadius.medium),
                                              bottomRight: Radius.circular(
                                                  Constant
                                                      .containerRadius.medium),
                                              bottomLeft: Radius.circular(
                                                  Constant
                                                      .containerRadius.medium)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              FxText.bodySmall(
                                                controller.chat[index].message!,
                                                color: controller.theme
                                                    .colorScheme.onPrimary,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: FxText.bodySmall(
                                                  dateToShow.toString(),
                                                  fontSize: 10,
                                                  color: controller.theme
                                                      .colorScheme.onPrimary,
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
                          });
                    }
                  }
                  if (snapshot.hasError) {
                    // print("**** snapshot.error ****");
                    // print(snapshot.error);
                    if (snapshot.error.toString().contains("errno = 103")) {
                      return Container(
                        child: Center(child: Text("Server is down.")),
                      );
                    }
                    //print("snapshot.data");
                    //print(snapshot.data);
                    return Container(
                      child: Center(child: Text("No Connection!")),
                    );
                  }
                  return Container();
                }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FxContainer(
              margin: EdgeInsets.only(left: 12, right: 12, bottom: 0, top: 12),
              // marginAll: 24,
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
                    onPressed: () {
                      if (controller.messageInput.value.length > 0) {
                        controller.sendMessage();
                        controller.messageInput.value = '';
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
        ],
      );
    }
  }
}
