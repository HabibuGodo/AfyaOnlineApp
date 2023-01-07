import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../componets/shared_function.controller.dart';
import '../controllers/dashboard_controller.dart';
import '../services/local_storage.dart';
import 'chat_screen.dart';
// import 'explore_screen.dart';
import 'home_screen.dart';
import 'my_items.dart';
import 'myfavorite.dart';
import 'profile_screen.dart';

class Dashboard extends GetView<DashboardController> {
  Dashboard({Key? key});


  Widget _widgetOptions(int index) {
    switch (controller.currentIndex.value) {
      case 0:
        // return Get.toNamed('/home');
        return HomeScreen();
      case 1:
        return authData.read('role') == "Dalali" ? MyItems() : MyFavorite();
      // case 2:
      //   return ChatScreen();
      case 2:
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
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                authData.read('role') == "Dalali"
                    ? BottomNavigationBarItem(
                        icon: Icon(Icons.aod_rounded),
                        label: 'My Items',
                      )
                    : BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'My Favorite',
                      ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.chat),
                //   label: 'Chat',
                // ),
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
              onTap: (index) {
                print(index);
                controller.handleTabSelection(index);
              },
            ),
          ),
        ));
  }
}
