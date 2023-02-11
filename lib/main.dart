import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutkit/src/services/LocalNotificationReceiverService.dart';
import 'package:flutkit/src/views/add_news.dart';
import 'package:flutkit/src/views/chats/groupchat_screen.dart';
import 'package:flutkit/src/views/chats/single_chat_screen.dart';
import 'package:flutkit/src/views/chats/single_users_list.dart';
import 'package:flutkit/localizations/app_localization_delegate.dart';
import 'package:flutkit/localizations/language.dart';
import 'package:flutkit/src/views/chats/user_list_to_add.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutkit/theme/app_notifier.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutx/themes/app_theme_notifier.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'src/bindings/insideBindings.dart';
import 'src/bindings/outsideBindings.dart';
import 'src/views/add_group.dart';
import 'src/views/dashboard.dart';
import 'src/views/login_otp.dart';
import 'src/views/login_screen.dart';
import 'src/views/otp_screen.dart';
import 'src/views/splash_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("message ${message.data}");
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  //open notif content from terminated state of the app
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      if (message.data['type'] == 'chat') {
        Get.toNamed('/single_chat', arguments: {
          'otherUserId': message.data['senderId'],
          'receiverName': message.data['senderName'],
          'receiverProfile': message.data['senderProfile'],
          'firebaseToken': message.data['senderFirebaseToken'],
        });
      }
    }
  });
}

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  // ======================flutter downloader
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  //=============================
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ChangeNotifierProvider<AppNotifier>(
    create: (context) => AppNotifier(),
    child: ChangeNotifierProvider<FxAppThemeNotifier>(
      create: (context) => FxAppThemeNotifier(),
      child: MyApp(),
    ),
  ));
  configLoading();
}

class MyApp extends StatefulWidget {
  const MyApp({key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        LocalNotificationService.displayNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['checkRoute'] == 'single') {
        Get.toNamed('/single_chat', arguments: {
          'otherUserId': message.data['senderId'],
          'receiverName': message.data['senderName'],
          'checkRoute': message.data['checkRoute'],
          'firebaseToken': message.data['senderFirebaseToken'],
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          title: 'Afya-HO',
          initialBinding: OutsideBindings(),
          builder: EasyLoading.init(),
          localizationsDelegates: [
            AppLocalizationsDelegate(context),
            // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: Language.getLocales(),
          home: SplashScreen(),
          getPages: [
            GetPage(
                name: '/',
                page: () => const SplashScreen(),
                transition: Transition.fadeIn),
            GetPage(
                name: '/login',
                page: () => const LoginScreen(),
                binding: OutsideBindings(),
                transition: Transition.rightToLeftWithFade),
            GetPage(
                name: '/login_otp',
                page: () => const LoginOTP(),
                binding: OutsideBindings(),
                transition: Transition.fadeIn),

            GetPage(
              name: '/otp_screen',
              page: () => const OTPScreen(),
              binding: OutsideBindings(),
              transition: Transition.circularReveal,
            ),
            // GetPage(
            //     name: '/register2',
            //     page: () => const Register2Screen(),
            //     binding: OutsideBindings(),
            //     transition: Transition.rightToLeftWithFade),

            //INSIDE APP

            GetPage(
                name: '/home',
                page: () => Dashboard(),
                binding: InsideBindings(),
                transition: Transition.circularReveal),

            GetPage(
                name: '/add_item',
                page: () => const AddNewsScreen(),
                binding: InsideBindings(),
                transition: Transition.leftToRightWithFade),

            GetPage(
                name: '/add_group',
                page: () => const AddGroupScreen(),
                binding: InsideBindings(),
                transition: Transition.leftToRightWithFade),

            GetPage(
                name: '/group_chat',
                page: () => const GroupChatScreen(),
                binding: InsideBindings(),
                transition: Transition.fadeIn),
            GetPage(
                name: '/adduser-to-group',
                page: () => const UserListToAddScreen(),
                binding: InsideBindings(),
                transition: Transition.fadeIn),
            GetPage(
                name: '/single_chat',
                page: () => const SingleChatScreen(),
                binding: InsideBindings(),
                transition: Transition.fadeIn),
            GetPage(
                name: '/user_list',
                page: () => const UserListScreen(),
                binding: InsideBindings(),
                transition: Transition.fadeIn),
          ],
        );
      },
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 3)
    ..indicatorType = EasyLoadingIndicatorType.ripple
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..customAnimation = CustomAnimation();
}

//========================Class for easy loading animation
class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}
