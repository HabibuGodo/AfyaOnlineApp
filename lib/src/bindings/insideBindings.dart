import 'package:flutkit/src/controllers/download_controller.dart';
import 'package:flutkit/src/controllers/single_agent_controller.dart';
import 'package:flutkit/src/controllers/single_house_controller.dart';
import 'package:get/get.dart';

import '../controllers/add_item_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/my_favorite_controller.dart';
import '../controllers/my_item_controller.dart';
import '../controllers/all_inside_chat_controller.dart';
import '../controllers/single_favorite_controller.dart';
import '../controllers/single_item_controller.dart';

class InsideBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());

    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    Get.lazyPut<SingleAgentController>(
      () => SingleAgentController(),
    );

    Get.lazyPut<SingleHouseController>(
      () => SingleHouseController(),
    );

    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
    Get.lazyPut<AllInsideChatController>(
      () => AllInsideChatController(),
    );
    Get.lazyPut<MyItemController>(
      () => MyItemController(),
    );
    Get.lazyPut<DownloadController>(
      () => DownloadController(),
    );
    Get.lazyPut<SingleItemController>(
      () => SingleItemController(),
    );
    Get.lazyPut<AddItemController>(
      () => AddItemController(),
    );
    Get.lazyPut<MyFavoriteController>(
      () => MyFavoriteController(),
    );

    Get.lazyPut<SingleFavoriteController>(
      () => SingleFavoriteController(),
    );
  }
}
