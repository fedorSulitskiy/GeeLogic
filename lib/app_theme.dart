import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:frontend/custom_page_route.dart';

/// Custom color scheme for the application.
class GeeLogicColourScheme extends ColorScheme {
  const GeeLogicColourScheme()
      : super(
          primary: blue,
          secondary: yellow,
          tertiary: green,
          surface: backgroundColour,
          background: backgroundColour,
          error: red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: iconGrey,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
          outline: borderGrey,
        );

  // Define named constants for your custom colors
  static const Color blue = Color.fromARGB(255, 66, 133, 244);
  static const Color yellow = Color.fromARGB(255, 244, 160, 0);
  static const Color red = Color.fromARGB(255, 219, 68, 55);
  static const Color green = Color.fromARGB(255, 15, 157, 88);
  static const Color iconGrey = Color.fromARGB(255, 110, 110, 110);
  static const Color borderGrey = Color.fromARGB(255, 203, 205, 214);
  static const Color backgroundColour = Color.fromARGB(255, 254, 251, 255);
  static const Color lightGrey = Color.fromARGB(255, 248, 248, 248);
}

/// Theme of the application.
final appTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const GeeLogicColourScheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.josefinSansTextTheme(),
    pageTransitionsTheme: const PageTransitionsTheme(
      // To be on the safe side I have included these animations for all platforms
      builders: {
        TargetPlatform.windows: CustomTransitionBuilder(),
        TargetPlatform.macOS: CustomTransitionBuilder(),
        TargetPlatform.linux: CustomTransitionBuilder(),
        TargetPlatform.android: CustomTransitionBuilder(),
        TargetPlatform.iOS: CustomTransitionBuilder(),
        TargetPlatform.fuchsia: CustomTransitionBuilder(),
      },
    ));
