import 'package:flutter/material.dart';

import '../../core/gen/colors.gen.dart';
import 'font_manager.dart';
import 'responsive/dimen.dart';
import 'style_manager.dart';

abstract class MainThemeApp {
  late ThemeData themeData;
}

class LightModeTheme implements MainThemeApp {
  @override
  ThemeData themeData = ThemeData(
    primaryColor: ColorName.colorPrimaryLight,
    cardColor: ColorName.colorCardLight,
    scaffoldBackgroundColor: ColorName.colorBackgroundLight,
    disabledColor: ColorName.colorGrey1,
    splashColor: ColorName.colorSplash,

    // Text color
    primaryColorLight: ColorName.colorFontPrimaryLight,
    primaryColorDark: ColorName.colorFontSecondaryLight,

    hintColor: ColorName.colorPlaceHolderLight,

    shadowColor: ColorName.colorBackgroundDark,

    fontFamily: FontConstants.fontDMSans,

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ColorName.colorBackgroundLight,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: ColorName.colorPrimaryLight,
      unselectedItemColor: ColorName.colorBlack,
    ),

    appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
            color: ColorName.colorFontPrimaryLight, size: AppSize.s20),
        titleTextStyle: getMediumStyle(
            fontSize: FontSize.s18, color: ColorName.colorFontPrimaryLight)),

    // input decoration theme (text form field)
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorName.colorTextFieldLight,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16, vertical: AppPadding.p20),
        // hint style
        hintStyle: getRegularStyle(color: ColorName.colorPlaceHolderLight),
        labelStyle: getMediumStyle(color: ColorName.colorFontPrimaryLight),
        errorStyle: getRegularStyle(color: ColorName.colorError),

        // enabled border style
        enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.transparent, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))),

        // focused border style
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorName.colorPrimaryLight, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))),

        // error border style
        errorBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorName.colorError, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))),
        // focused border style
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorName.colorPrimaryLight, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s10)))),
  );
}
