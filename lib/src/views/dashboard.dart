import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../componets/shared_function.controller.dart';
import '../controllers/global.dart';
import '../controllers/dashboard_controller.dart';
import '../services/local_storage.dart';
// import 'explore_screen.dart';
import 'chats/group_list_screen.dart';
import 'chats/chats_landpage.dart';
import 'chats/single_chat_screen.dart';
import 'chats/single_user_convo_list.dart';
import 'download_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class Dashboard extends GetView<DashboardController> {
  Dashboard({Key? key});

  Widget _widgetOptions(int index) {
    switch (controller.currentIndex.value) {
      case 0:
        return SingleUserConvoListScreen();
      case 1:
        return HomeScreen();
      case 2:
        return GroupListScreen();
      case 3:
        return DownloadScreen();
      case 4:
        return ProfileScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: SharedFunctionController.onWillPop,
          child: Scaffold(
            body: _widgetOptions(controller.currentIndex.value),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Global.totalUnreadAllConvo.value == 0
                      ? Icon(CupertinoIcons.chat_bubble_2)
                      : Badge(
                          badgeContent: Obx(
                            () => Text(
                              Global.totalUnreadAllConvo.value.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                          child: Icon(CupertinoIcons.chat_bubble_2),
                        ),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.feed),
                  label: 'Share',
                ),
                // authData.read('role') == "Dalali"
                //     ? BottomNavigationBarItem(
                //         icon: Icon(Icons.aod_rounded),
                //         label: 'My Items',
                //       )
                //     : BottomNavigationBarItem(
                //         icon: Icon(Icons.favorite),
                //         label: 'My Favorite',
                //       ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Groups',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.download),
                  label: 'Download',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: controller.currentIndex.value,
              selectedItemColor: controller.theme.colorScheme.primary,
              unselectedItemColor: Color.fromARGB(255, 58, 83, 78),
              showUnselectedLabels: true,
              showSelectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              onTap: (index) {
                print(index);
                controller.handleTabSelection(index);
              },
            ),
          ),
        ));
  }
}
