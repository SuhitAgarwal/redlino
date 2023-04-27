import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const symHPadding20 = EdgeInsets.symmetric(horizontal: 20);
final borderRadiusMd = BorderRadius.circular(16);
final borderRadiusSm = BorderRadius.circular(8);
final maxBorderRadius = BorderRadius.circular(9999);

final borderRadiusSmShape = RoundedRectangleBorder(
  borderRadius: borderRadiusSm,
);
final borderRadiusMdShape = RoundedRectangleBorder(
  borderRadius: borderRadiusMd,
);
final maxBorderRadiusShape = RoundedRectangleBorder(
  borderRadius: maxBorderRadius,
);

const lilacBlue = Color(0xFF7C7DC9);
const red = Color(0xFFEB5757);
const gray = Color(0xFFA1A4B2);
const darkGray = Color(0xFF6E7076);

const blackTextStyle = TextStyle(color: Colors.black);

const kSnackbarDuration = Duration(seconds: 2);

final _inputTheme = InputDecorationTheme(
  labelStyle: GoogleFonts.sourceSansPro(
    fontSize: 16,
    letterSpacing: 0.5,
  ),
);

final textTheme = TextTheme(
  headline1: GoogleFonts.rubik(
    fontSize: 98,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
    color: Colors.black,
  ),
  headline2: GoogleFonts.rubik(
    fontSize: 61,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
    color: Colors.black,
  ),
  headline3: GoogleFonts.rubik(
    fontSize: 49,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  ),
  headline4: GoogleFonts.rubik(
    fontSize: 35,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: Colors.black,
  ),
  headline5: GoogleFonts.rubik(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  ),
  headline6: GoogleFonts.rubik(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: Colors.black,
  ),
  subtitle1: GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: Colors.black,
  ),
  subtitle2: GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: Colors.black,
  ),
  bodyText1: GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  ),
  bodyText2: GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  button: GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  ),
  caption: GoogleFonts.rubik(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  ),
  overline: GoogleFonts.rubik(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
  ),
);

final _bsTheme = BottomSheetThemeData(
  backgroundColor: Colors.black.withOpacity(0),
);

final _txtBtnTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    minimumSize: const Size(125, 36),
    shape: RoundedRectangleBorder(borderRadius: borderRadiusSm),
  ),
);

final lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  inputDecorationTheme: _inputTheme,
  bottomSheetTheme: _bsTheme,
  textTheme: textTheme,
  textButtonTheme: _txtBtnTheme,
  appBarTheme: AppBarTheme(
    backwardsCompatibility: false,
    titleTextStyle: GoogleFonts.rubik(
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  inputDecorationTheme: _inputTheme,
  bottomSheetTheme: _bsTheme,
  textTheme: textTheme,
  textButtonTheme: _txtBtnTheme,
  appBarTheme: AppBarTheme(
    backwardsCompatibility: false,
    titleTextStyle: GoogleFonts.rubik(
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
  ),
);
