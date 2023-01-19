import 'package:flutkit/src/controllers/download_controller.dart';
import 'package:get/get.dart';

import '../controllers/add_newsfeed_controller.dart';
import '../controllers/chats/chat_controller.dart';
import '../controllers/chats/user_to_add_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/share_controller.dart';
import '../controllers/chats/all_inside_chat_controller.dart';

class InsideBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());

    Get.lazyPut<ShareController>(
      () => ShareController(),
    );

    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
    Get.lazyPut<AllInsideChatController>(
      () => AllInsideChatController(),
    );
    Get.lazyPut<UserToAddController>(
      () => UserToAddController(),
    );

    Get.lazyPut<DownloadController>(
      () => DownloadController(),
    );
    Get.lazyPut<AddINewsController>(
      () => AddINewsController(),
    );
  }
}
