import 'package:flutter/material.dart';

class LightMode {
  static const Color _primaryColor = Color(0xFFF94D1F);
  static const Color _screenBackgroundColor = Colors.white;
  static const Color _fontColor = Colors.black;
  static const Color _greyFontColor = Color(0xFF787878);
  static const Color _darkGreyColor = Color(0xFF969389);
  static const Color _inputBorderColor = Color(0xFFEAEEF1);
  static const Color _inputBgColor = Colors.white;
  static const Color _curvedImageColor = Color(0xFFFFFFFF);
  static const Color _hintTextColor = Color(0xFF726464);
  static const Color _containerShadowColor = Color(0xFFf5f0f9);
  static const Color _shimmerBaseColor = Color(0xFFf1f2f6);
  static const Color _shimmerHighlightColor = Colors.white;

  static ThemeData theme() => ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: _screenBackgroundColor,
        appBarTheme: AppBarTheme(
          toolbarHeight: 66,
          backgroundColor: _screenBackgroundColor,
          surfaceTintColor: _screenBackgroundColor,
          elevation: 1.6,
          shadowColor: Colors.grey.shade200,
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          primaryContainer: _curvedImageColor,
          seedColor: _primaryColor,
          primary: _primaryColor,
          onPrimary: _fontColor,
          secondary: _darkGreyColor,
          outline: _inputBorderColor,
          surface: _inputBgColor,
          shadow: _containerShadowColor,
          tertiary: _shimmerBaseColor,
          onTertiary: _shimmerHighlightColor,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          displaySmall: TextStyle(
            color: _greyFontColor,
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.8,
          ),
          headlineLarge: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 38,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          headlineSmall: TextStyle(
            color: _primaryColor,
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            color: Color(0xFF808080),
          ),
          bodyLarge: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodySmall: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          labelMedium: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          constraints: const BoxConstraints(minHeight: 50),
          filled: true,
          fillColor: _inputBgColor,
          hintStyle: TextStyle(
              color: _hintTextColor.withOpacity(0.6),
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: _inputBorderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: _inputBorderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: _inputBorderColor,
            ),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          subtitleTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: const TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}

class DarkMode {
  static const Color _primaryColor = Color(0xFFF94D1F);
  static const Color _screenBackgroundColor = Colors.black;
  static const Color _fontColor = Colors.white;
  static const Color _darkGreyColor = Color(0xFF969389);
  static const Color _inputBorderColor = Color(0xFF444444);
  static const Color _inputBgColor = Color(0xFF111111);
  static const Color _curvedImageColor = Colors.black;
  static const Color _hintTextColor = Colors.white;
  static const Color _containerShadowColor = Colors.black;
  static const Color _shimmerBaseColor = Color(0xFF353b48);
  static const Color _shimmerHighlightColor = Color(0xFF596275);

  static ThemeData theme() => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: _screenBackgroundColor,
        appBarTheme: AppBarTheme(
          toolbarHeight: 66,
          backgroundColor: _screenBackgroundColor,
          surfaceTintColor: _screenBackgroundColor,
          elevation: 1.6,
          shadowColor: Colors.grey.shade200,
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          primaryContainer: _curvedImageColor,
          seedColor: _primaryColor,
          primary: _primaryColor,
          onPrimary: _fontColor,
          secondary: _darkGreyColor,
          outline: _inputBorderColor,
          surface: _inputBgColor,
          shadow: _containerShadowColor,
          tertiary: _shimmerBaseColor,
          onTertiary: _shimmerHighlightColor,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          displaySmall: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.8,
          ),
          headlineLarge: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 38,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          headlineSmall: TextStyle(
            color: _primaryColor,
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodySmall: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          labelMedium: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: TextStyle(
            color: _fontColor,
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          constraints: const BoxConstraints(minHeight: 50),
          filled: true,
          fillColor: _inputBgColor,
          hintStyle: TextStyle(
              color: _hintTextColor.withOpacity(0.6),
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: _inputBorderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: _inputBorderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: _inputBorderColor,
            ),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          subtitleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: const TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}
