import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/src/controllers/chats/chat_controller.dart';
import 'package:flutkit/src/models/conversationModel.dart';
import 'package:flutkit/src/models/group_model.dart';
import 'package:flutkit/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

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
                    "No any converstation",
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
                        var otherUserId;
                        if (controller.allConvo[index].receiverId !=
                            authData.read('id')) {
                          otherUserId = controller.allConvo[index].receiverId;
                        } else {
                          otherUserId = controller.allConvo[index].senderId;
                        }
                        Get.toNamed('/single_chat', arguments: {
                          'otherUserId': otherUserId,
                          'receiverName': controller
                              .allConvo[index].receiverName
                              .toString(),
                        });
                      },
                      child: Column(
                        children: [
                          ListTile(
                              leading: Icon(FeatherIcons.user),
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
                                              controller
                                                  .allConvo[index].lastMessage!,
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
                                              controller
                                                  .allConvo[index].lastMessage!,
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
                                          controller
                                              .allConvo[index].lastMessage!,
                                          xMuted: true,
                                          muted: true,
                                          fontWeight: 400,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : FxText.bodySmall(
                                          controller
                                              .allConvo[index].lastMessage!,
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
          return Container();
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
              Icons.add,
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
      children: 
      [
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




// class SingleUserConvoListScreen extends GetView<ChatController> {
//   SingleUserConvoListScreen({Key? key});

//   List<Widget> _buildChatList() {
//     List<Widget> list = [];
//     list.add(FxSpacing.width(16));
//     if (controller.allConvo.length == 0) {
//       list.add(Container(
//         margin: FxSpacing.top(200),
//         child: Center(
//           child: FxText.sh1(
//             "No any conversation",
//             color: controller.theme.colorScheme.onBackground,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ));
//     } else {
//       for (CoversatationModel convo in controller.allConvo) {
//         list.add(_buildSingleChat(convo));
//         list.add(Divider());
//       }
//     }
//     return list;
//   }

//   Widget _buildSingleChat(CoversatationModel convo) {
//     return InkWell(
//       onTap: () {
//         Get.toNamed('/single_chat', arguments: {
//           'receiverId': convo.receiverId,
//           'receiverName': convo.receiverName.toString(),
//           'checkRoute': "single"
//         });
//       },
//       child: Row(
//         children: [
//           Icon(FeatherIcons.user),
//           FxSpacing.width(16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 FxText.bodyMedium(
//                   convo.receiverName!.toString(),
//                   fontWeight: 600,
//                   fontSize: 15,
//                 ),
//               ],
//             ),
//           ),
//           FxSpacing.width(6),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Theme(
//         data: controller.theme.copyWith(
//             colorScheme: controller.theme.colorScheme
//                 .copyWith(secondary: controller.theme.primaryColor)),
//         child: Scaffold(
//           body: RefreshIndicator(
//             onRefresh: () async {
//               controller.getConvoList();
//             },
//             child: Container(
//               padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
//               child: Column(
//                 children: [
//                   Container(
//                     height: 2,
//                     child: controller.showLoading.value
//                         ? LinearProgressIndicator(
//                             color: controller.theme.colorScheme.primary,
//                             minHeight: 2,
//                           )
//                         : Container(
//                             height: 2,
//                           ),
//                   ),
//                   Expanded(
//                     child: _buildBody(),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // floating action button
//           floatingActionButton: authData.read("role") == 2
//               ? Container()
//               : FloatingActionButton(
//                   onPressed: () {
//                     Get.toNamed('/user_list');
//                   },
//                   backgroundColor: controller.theme.colorScheme.primary,
//                   child: const Icon(
//                     Icons.add,
//                     color: Colors.white,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (controller.uiLoading.value) {
//       return Container(
//           child: LoadingEffect.getSearchLoadingScreen(
//         Get.context!,
//       ));
//     } else {
//       return ListView(
//         padding: FxSpacing.x(20),
//         children: [
//           FxSpacing.height(16),
//           FxTextField(
//             textFieldStyle: FxTextFieldStyle.outlined,
//             labelText: 'Search User...',
//             focusedBorderColor: controller.theme.colorScheme.onPrimary,
//             enabledBorderRadius: Constant.containerRadius.medium,
//             focusedBorderRadius: Constant.containerRadius.medium,
//             cursorColor: controller.theme.colorScheme.onPrimary,
//             labelStyle: FxTextStyle.bodySmall(
//                 color: controller.theme.colorScheme.onPrimary, xMuted: false),
//             floatingLabelBehavior: FloatingLabelBehavior.never,
//             filled: true,
//             fillColor: controller.theme.colorScheme.primary.withOpacity(0.5),
//             suffixIcon: Icon(
//               FeatherIcons.search,
//               color: controller.theme.colorScheme.onPrimary,
//               size: 20,
//             ),
//             onChanged: (value) {
//               controller.filterUsersList(value);
//             },
//           ),
//           FxSpacing.height(20),
//           Column(
//             children: _buildChatList(),
//           ),
//         ],
//       );
//     }
//   }
// }
