import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutkit/src/controllers/chats/chat_controller.dart';
import 'package:flutkit/src/controllers/global.dart';
import 'package:flutkit/src/services/base_service.dart';
import 'package:flutkit/theme/constant.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../loading_effect.dart';
import '../../services/local_storage.dart';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class SingleUserConvoListScreen extends GetView<ChatController> {
  const SingleUserConvoListScreen({Key? key});

  Widget _buildSingleChat() {
    return StreamBuilder(
        stream: controller.getConvoListStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (controller.allConvo.length == 0) {
              return Container(
                margin: FxSpacing.top(250),
                child: Center(
                  child: FxText.sh1(
                    "No any conversation",
                    color: controller.theme.colorScheme.onBackground,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.allConvo.length,
                  itemBuilder: (context, index) {
                    DateTime tempDate = new DateFormat("dd-MM-yyyy hh:mm")
                        .parse(controller.allConvo[index].lastMessageTime!
                            .toString());
                    // var date = DateTime.parse(messageText.createdAt!);
                    var now = DateTime.now();
                    var yesterday = now.subtract(Duration(days: 1));
                    var dateToShow = "";
                    if (tempDate.day == now.day &&
                        tempDate.month == now.month &&
                        tempDate.year == now.year) {
                      dateToShow = DateFormat.jm().format(tempDate).toString();
                    } else if (tempDate.day == yesterday.day &&
                        tempDate.month == yesterday.month &&
                        tempDate.year == yesterday.year) {
                      dateToShow = "Yesterday";
                    } else {
                      dateToShow =
                          DateFormat.yMMMd().format(tempDate).toString();
                    }
                    return InkWell(
                      onTap: () {
                        // Global.singleChat.clear();
                        var otherUserId;
                        if (controller.allConvo[index].receiverId !=
                            authData.read('user_id')) {
                          otherUserId = controller.allConvo[index].receiverId;
                        } else {
                          otherUserId = controller.allConvo[index].senderId;
                        }

                        Get.toNamed('/single_chat', arguments: {
                          'otherUserId': otherUserId,
                          'receiverName': controller
                              .allConvo[index].receiverName
                              .toString(),
                          'receiverProfile': controller
                              .allConvo[index].receiverProfile
                              .toString(),
                          'firebaseToken':
                              controller.allConvo[index].firebaseToken,
                          'checkRoute': "single"
                        });
                      },
                      child: Column(
                        children: [
                          ListTile(
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                      imageUrl: imageURL +
                                          controller
                                              .allConvo[index].receiverProfile
                                              .toString(),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
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
                              title: FxText.bodyMedium(
                                controller.allConvo[index].receiverName
                                    .toString(),
                                // fontWeight: 500,
                                fontSize: 15,
                              ),
                              subtitle: (controller
                                          .allConvo[index].lastMsgReceiverId !=
                                      authData.read("user_id"))
                                  ? controller.allConvo[index].readStatus == 0
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.done_all,
                                              size: 14,
                                            ),
                                            FxText.bodySmall(
                                              controller.allConvo[index]
                                                      .lastMessage ??
                                                  "",
                                              xMuted: true,
                                              muted: true,
                                              fontWeight: 400,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Icon(
                                              Icons.done_all,
                                              size: 14,
                                              color: Colors.blue,
                                            ),
                                            FxText.bodySmall(
                                              controller.allConvo[index]
                                                      .lastMessage ??
                                                  "",
                                              xMuted: true,
                                              muted: true,
                                              fontWeight: 400,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )
                                  : controller.allConvo[index].readStatus == 1
                                      ? FxText.bodySmall(
                                          controller.allConvo[index]
                                                  .lastMessage ??
                                              "",
                                          xMuted: true,
                                          muted: true,
                                          fontWeight: 400,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : FxText.bodySmall(
                                          controller.allConvo[index]
                                                  .lastMessage ??
                                              "",
                                          // xMuted: true,
                                          // muted: true,
                                          fontWeight: 900,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  controller.allConvo[index].totalUnread! > 0
                                      ? Badge(
                                          badgeContent: FxText.bodyMedium(
                                            controller
                                                .allConvo[index].totalUnread
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          child: Icon(
                                            CupertinoIcons.square_list,
                                            color: Colors.transparent,
                                          ),
                                        )
                                      : Icon(
                                          CupertinoIcons.square_list,
                                          color: Colors.transparent,
                                        ),
                                  // FxText.caption(dateToShow)
                                ],
                              )),
                          Divider(
                            height: 1,
                            // thickness: 1,
                          ),
                        ],
                      ),
                    );
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
          return Container(
              child: LoadingEffect.getSearchLoadingScreen(
            Get.context!,
          ));
        });
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
              controller.getSingleConvoList();
            },
            child: Container(
              padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
              child: Column(
                children: [
                  Container(
                    height: 0.3,
                    child: controller.showLoading.value
                        ? LinearProgressIndicator(
                            color: Colors.transparent,
                            minHeight: 0.1,
                          )
                        : Container(
                            height: 0.3,
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // _openCustomDialog();
              Get.toNamed('/user_list');
            },
            backgroundColor: controller.theme.primaryColor,
            child: const Icon(
              Icons.chat_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: FxSpacing.x(20),
      children: [
        FxSpacing.height(16),
        FxTextField(
          textFieldStyle: FxTextFieldStyle.outlined,
          labelText: 'Search Users...',
          focusedBorderColor: controller.theme.colorScheme.onPrimary,
          enabledBorderRadius: Constant.containerRadius.medium,
          focusedBorderRadius: Constant.containerRadius.medium,
          cursorColor: controller.theme.colorScheme.onPrimary,
          labelStyle: FxTextStyle.bodySmall(
              color: controller.theme.colorScheme.onPrimary, xMuted: false),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: controller.theme.primaryColor.withOpacity(0.5),
          suffixIcon: Icon(
            FeatherIcons.search,
            color: controller.theme.colorScheme.onPrimary,
            size: 20,
          ),
          onChanged: (value) {
            controller.filterConvoList(value);
          },
        ),
        FxSpacing.height(20),
        _buildSingleChat(),
      ],
    );
  }
  // }

}
