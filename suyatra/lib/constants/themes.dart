import 'package:flutter/material.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    fontFamily: "InstrumentSans",
    useMaterial3: false,
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
      elevation: 0,
      toolbarHeight: 64.0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: h8,
        fontFamily: "InstrumentSans",
        fontWeight: FontWeight.w600,
        color: blackColor,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryDark,
    )
  );
}