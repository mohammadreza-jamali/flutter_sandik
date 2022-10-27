import 'package:flutter/material.dart';

class AppStyle {
  static double smallFontSize = scaleFont(12);
  static double smallIconSize = scaleFont(35);
  static double mediumIconSize = scaleFont(40);
  static double buttonIconSize = scaleFont(25);
  static double largeIconSize = 60;
  static double cardRadius = 12.0;
  static double commonRadius = 8;
  static double lowEdgeInset = 4;
  static double normalEdgeInset = 8;
  static double highEdgeInset = 16;
  static Image appBarIcon = Image.asset(
    'assets/images/logo.png',
    height: 120,
  );
  static MaterialStateBorderSide linkButtonBorder =
      MaterialStateBorderSide.resolveWith((states) => BorderSide.none);

  static MaterialColor shadowColor = Colors.grey;
  static Color backgroundColor = Colors.grey.shade200;
  static Color borderColor = Colors.grey.shade300;
  static Color mainColor = Colors.white;
  static Color blackWithOpacity = Colors.black45;
  static Color whiteWithOpacity = Colors.white54;
  static Color black = Colors.black;
  static const Color deepBlue = Colors.blue;
  static Color appBlue = Colors.blueAccent.shade400.withOpacity(0.3);
  static Color deepGreen = Colors.green.shade800;
  static Color disabledGreen = Colors.green.shade800.withOpacity(0.2);
  static final Color deepRed = Colors.red.shade800;
  static Color disabledRed = Colors.red.shade800.withOpacity(0.2);
  static Color deepYellow = Colors.yellow.shade800;
  static Color disabledYellow = Colors.yellow.shade800.withOpacity(0.2);
  static Color transparent = Colors.transparent;
  static double scaleSize = 1.0;
  static Color gradiantStartColor = const Color(0xff23b6e6);
  static Color gradiantEndColor = Color.fromARGB(255, 2, 53, 163);

  static TextStyle red11 = TextStyle(fontSize: scaleFont(11), color: deepRed);

  static TextStyle regular14 = TextStyle(fontSize: scaleFont(14));
  static TextStyle regular12 = TextStyle(fontSize: scaleFont(12));

  static TextStyle bold12 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: scaleFont(12));
  static TextStyle bold14 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: scaleFont(14));

  static TextStyle bold16 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: scaleFont(16));
  static TextStyle bold18 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: scaleFont(18));
  static TextStyle bold20 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: scaleFont(20));
  static TextStyle boldWhite24 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: scaleFont(24),
      color: Colors.white);

  static TextStyle bold24Blue =
      const TextStyle(fontSize: 24, color: Colors.blue, letterSpacing: 5);

  static OutlineInputBorder commonRadiusBorder =
      OutlineInputBorder(borderRadius: BorderRadius.circular(commonRadius));
  static OutlineInputBorder curvedLightInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(36));

  static UnderlineInputBorder bottomLightInputBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(4));
  static BoxShadow blueShadow =
      BoxShadow(color: shadowColor, blurRadius: 6, spreadRadius: 1);
  static BoxDecoration dividerDecoration = BoxDecoration(boxShadow: [
    BoxShadow(
        blurRadius: 1,
        spreadRadius: 0,
        color: Colors.blue.shade400.withOpacity(0.4),
        offset: const Offset(0, 0))
  ]);
  static ColorScheme colorSchemeLight = ColorScheme(
    primary: Color(0xffbabfd1),
    secondary: Colors.white,
    surface: Colors.white,
    background: Colors.white,
    brightness: Brightness.light,
    error: deepRed,
    onBackground: Colors.white,
    onError: Color(0xffbabfd1),
    onPrimary: Color(0xffbabfd1),
    onSecondary: Color(0xffbabfd1),
    onSurface: Color(0xffbabfd1),
  );
  static double scaleFont(double size) {
    var diffrence = 0.0;
    if (scaleSize < 1) {
      diffrence = scaleSize - 0.87;
    } else if (scaleSize > 1) {
      diffrence = scaleSize - 1.13;
    } else {
      return size;
    }
    return size - (size * diffrence);
  }

  static ThemeData lightTheme = ThemeData(
      colorScheme: colorSchemeLight,
      brightness: Brightness.light,
      inputDecorationTheme: InputDecorationTheme(
        iconColor: Color(0xFF607196),
        labelStyle: TextStyle(color: Color(0xFF607196)),
        hintStyle: TextStyle(color: Color(0xFF607196)),
        fillColor: Color(0xffbabfd1),
        enabledBorder: bottomLightInputBorder,
        focusedBorder: bottomLightInputBorder,
        border: bottomLightInputBorder,
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: Color(0xffbabfd1),
          actionsIconTheme: IconThemeData(color: Color(0xFF607196)),
          centerTitle: true,
          foregroundColor: Color(0xFF607196)),
      selectedRowColor: Color(0xffbabfd1).withOpacity(0.8),
      highlightColor: Color(0xffbabfd1).withOpacity(0.8),
      primaryColor: Colors.white,
      hintColor: Color(0xFFFF7B9C),
      cardColor: const Color(0xFFFFC759),
      canvasColor: Color(0xFFE8E9ED),
      backgroundColor: Color(0xFFE8E9ED),
      disabledColor: Color(0xffbabfd1),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Color(0xFF607196)),
        bodyText2: TextStyle(color: Color(0xFF607196)),
        caption: TextStyle(color: Color(0xFF607196)),
        headline1: TextStyle(color: Color(0xFF607196)),
        headline2: TextStyle(color: Color(0xFF607196)),
        headline3: TextStyle(color: Color(0xFF607196)),
        headline4: TextStyle(color: Color(0xFF607196)),
        headline5: TextStyle(color: Color(0xFF607196)),
        headline6: TextStyle(color: Color(0xFF607196)),
        subtitle1: TextStyle(color: Color(0xFF607196)),
        subtitle2: TextStyle(color: Color(0xFF607196)),
      ));

  static ColorScheme colorSchemeDark = ColorScheme(
    primary: const Color(0xFF607196),
    secondary: Colors.white,
    surface: Colors.white,
    background: Colors.white,
    brightness: Brightness.dark,
    error: deepRed,
    onBackground: Colors.white,
    onError: const Color(0xFF607196),
    onPrimary: const Color(0xFF607196),
    onSecondary: const Color(0xFF607196),
    onSurface: const Color(0xFF607196),
  );
  static ThemeData darkTheme = ThemeData(
      colorScheme: colorSchemeDark,
      brightness: Brightness.dark,
      inputDecorationTheme: InputDecorationTheme(
        iconColor: Color(0xFF607196),
        labelStyle: TextStyle(color: Color(0xFF607196)),
        hintStyle: TextStyle(color: Color(0xFF607196)),
        enabledBorder: bottomLightInputBorder,
        focusedBorder: bottomLightInputBorder,
        border: bottomLightInputBorder,
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF607196),
          actionsIconTheme: IconThemeData(color: Color(0xFFE8E9ED)),
          centerTitle: true,
          foregroundColor: Color(0xFFE8E9ED)),
      selectedRowColor: Color(0xFF607196).withOpacity(0.8),
      highlightColor: const Color(0xFF607196).withOpacity(0.8),
      primaryColor: Color(0xFFE8E9ED),
      backgroundColor: Color(0xffbabfd1),
      hintColor: Color(0xFFFF7B9C),
      cardColor: const Color(0xFFFFC759),
      canvasColor: Color(0xffbabfd1),
      disabledColor: Color(0xffbabfd1),
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: Color(0xFF607196)),
        bodyText2: TextStyle(color: Color(0xFF607196)),
        caption: TextStyle(color: Color(0xFF607196)),
        headline1: TextStyle(color: Color(0xFF607196)),
        headline2: TextStyle(color: Color(0xFF607196)),
        headline3: TextStyle(color: Color(0xFF607196)),
        headline4: TextStyle(color: Color(0xFF607196)),
        headline5: TextStyle(color: Color(0xFF607196)),
        headline6: TextStyle(color: Color(0xFF607196)),
        subtitle1: TextStyle(color: Color(0xFF607196)),
        subtitle2: TextStyle(color: Color(0xFFE8E9ED)),
      ));
}
