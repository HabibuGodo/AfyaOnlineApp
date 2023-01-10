import 'package:flutkit/src/views/add_item.dart';
import 'package:flutkit/src/views/chats/groupchat_screen.dart';
import 'package:flutkit/src/views/chats/single_chat_screen.dart';
import 'package:flutkit/src/views/chats/single_users_list.dart';
import 'package:flutkit/src/views/register_screen1.dart';
import 'package:flutkit/localizations/app_localization_delegate.dart';
import 'package:flutkit/localizations/language.dart';
import 'package:flutkit/src/views/single_favorite_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutkit/theme/app_notifier.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutx/themes/app_theme_notifier.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'src/bindings/insideBindings.dart';
import 'src/bindings/outsideBindings.dart';
import 'src/views/add_group.dart';
import 'src/views/contactus.dart';
import 'src/views/dashboard.dart';
import 'src/views/login_otp.dart';
import 'src/views/login_screen.dart';
import 'src/views/otp_screen.dart';
import 'src/views/single_agent_screen.dart';
import 'src/views/single_house_screen.dart';
import 'src/views/single_item_screen.dart';
import 'src/views/splash_screen.dart';

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
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

class MyApp extends StatelessWidget {
  const MyApp({key});
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

          //  (context, child) {
          //   EasyLoading.init(

          //   );
          //   return Directionality(
          //     textDirection: AppTheme.textDirection,
          //     child: child!,
          //   );
          // },
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
                name: '/register',
                page: () => const Register1Screen(),
                binding: OutsideBindings(),
                transition: Transition.rightToLeftWithFade),
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
                name: '/single_house',
                page: () => const SingleHouseScreen(),
                binding: InsideBindings(),
                transition: Transition.downToUp),
            GetPage(
                name: '/single_item',
                page: () => const SingleItemScreen(),
                binding: InsideBindings(),
                transition: Transition.leftToRightWithFade),
            GetPage(
                name: '/add_item',
                page: () => const AddItemScreen(),
                binding: InsideBindings(),
                transition: Transition.leftToRightWithFade),

            GetPage(
                name: '/add_group',
                page: () => const AddGroupScreen(),
                binding: InsideBindings(),
                transition: Transition.leftToRightWithFade),

            GetPage(
                name: '/single_favorite_item',
                page: () => const SingleFavoriteScreen(),
                binding: InsideBindings(),
                transition: Transition.leftToRightWithFade),

            GetPage(
                name: '/single_agent',
                page: () => const SingleAgentScreen(),
                binding: InsideBindings(),
                transition: Transition.downToUp),
            GetPage(
                name: '/group_chat',
                page: () => const GroupChatScreen(),
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

            GetPage(
                name: '/contact-us',
                page: () => ContactUsPage(),
                transition: Transition.fadeIn)
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
