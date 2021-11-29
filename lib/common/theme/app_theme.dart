import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    canvasColor: AppColor.white,
    primaryColor: AppColor.black,
    fontFamily: "Inter",
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.white,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: AppColor.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: AppColor.black,
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      headline5: TextStyle(
        color: AppColor.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      headline6: TextStyle(
        color: AppColor.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyText1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyText2: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
