import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/pages/landing_page.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  runApp(EasyLocalization(
    child: const MyApp(),
    supportedLocales: [
      Locale('en'),
      Locale('tr'),
    ],
    path: 'assets/translations',
    fallbackLocale: Locale('tr'),
    saveLocale: true,
    useOnlyLangCode: false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (context) => UserModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MTransaction(),
        ),
      ], builder: (context, child) => MaterialApp(
      title: 'Sandik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
    ));
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: LandingPage(),
      duration: 3000,
      imageSize: 700,
      imageSrc: "assets/images/splash.jpg",
      backgroundColor: Colors.orange,
    );
  }
}
