import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/components/constants.dart';

ThemeData defaultTheme =ThemeData(
  primarySwatch: defaultColor,
  appBarTheme: const AppBarTheme(
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: Colors.white,
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    )  ,
  ),
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme:  BottomNavigationBarThemeData(
    selectedItemColor: defaultColor,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    elevation: 0.0,
  )

);