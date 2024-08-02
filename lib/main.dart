import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_sandik/core/application/navigation_service.dart';
import 'package:flutter_sandik/core/application/theme_manager.dart';
import 'package:flutter_sandik/core/entities/dtos/theme_dto.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/pages/landing_page.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/provider.dart';


Future init() async{
  await Future.delayed(Duration(seconds: 3));
  FlutterNativeSplash.remove();
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  init();

  runApp(EasyLocalization(
    child: const MyApp(),
    supportedLocales: [
      Locale('en'),
      Locale('fa'),
    ],
    path: 'assets/translations',
    fallbackLocale: Locale('fa'),
    saveLocale: true,
    useOnlyLangCode: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeManager _themeManager;
  late ThemeDto currentTheme;
  late EventBus _eventBus;

  @override
  void initState() {
    super.initState();
    _themeManager = locator<ThemeManager>();
    currentTheme = _themeManager.getTheme();
    _eventBus = locator<EventBus>();
    _eventBus.on<ThemeDto>().listen((event) {
      currentTheme = event;
      if (mounted) setState(() {});
    });
    _themeManager.createTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => MTransaction(),
          ),
        ],
        builder: (context, child) => MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: 'Sandik',
              debugShowCheckedModeBanner: false,
              theme: currentTheme.theme,
              home: LandingPage(),
              navigatorKey: locator<NavigationService>().navigatorKey,
            ));
  }
}

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SplashScreenView(
//       navigateRoute: LandingPage(),
//       duration: 3000,
//       imageSize: 700,
//       imageSrc: "assets/images/splash.jpg",
//       backgroundColor: Colors.orange,
//     );
//   }
// }
