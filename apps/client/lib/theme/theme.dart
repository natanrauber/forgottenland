import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forgottenland/theme/colors.dart';

ThemeData appTheme() => ThemeData(
      brightness: Brightness.light,

      fontFamily: 'NunitoSans',

      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.primary,

      colorScheme: const ColorScheme(
        primary: AppColors.primary,
        secondary: AppColors.yellow,
        surface: AppColors.bgDefault,
        background: AppColors.bgDefault,
        error: AppColors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
        brightness: Brightness.light,
      ),

      errorColor: const Color(0xFFF31629),

      backgroundColor: AppColors.bgDefault,
      scaffoldBackgroundColor: AppColors.bgDefault,

      iconTheme: const IconThemeData(color: AppColors.primary),

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppColors.primary,
        titleTextStyle: TextStyle(
          fontFamily: 'NunitoSans',
          letterSpacing: 1,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.black80,
        ),
      ),

      /// text theme
      textTheme: const TextTheme(
        //
        titleMedium: TextStyle(
          fontFamily: 'NunitoSans',
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
          color: AppColors.textPrimary,
        ),

        bodyMedium: TextStyle(
          fontFamily: 'NunitoSans',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
          color: AppColors.textPrimary,
        ),
      ),

      /// selected text
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary,
        selectionHandleColor: AppColors.primary,
      ),

      /// text input
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: AppColors.bgPaper,
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: AppColors.primary),
        floatingLabelStyle: TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(color: AppColors.bgPaper),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(color: AppColors.bgPaper),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(color: AppColors.bgPaper),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(color: AppColors.bgPaper),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(color: AppColors.red),
        ),
      ),

      /// dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),

      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: AppColors.bgPaper,
      ),
    );
