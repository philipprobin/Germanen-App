import 'package:flutter/material.dart';

class AppColor {
  static Color primary = Color(0xFFDA2A2A);
  static Color primarySoft = Color(0xFF337D5E);
  static Color primaryExtraSoft = Color(0xFF44A67D);
  static Color secondaryHard = Color(0xFF8B6220);
  static Color secondary = Color(0xFFFFFFFF);
  static Color whiteSoft = Color(0xFFF8F8F8);
  static Color tertiary = Color(0xFFD64933);
  static Color background = Color(0xFFfffcfc);
  static Color deactivated = Color(0xFFf2f2f2);
  static Color text = Colors.black;
  static Color grey = Color(0xFF939393);
  static Color minimalAccent = Color(0xFFF2F2F2);
  static Color borderColor = Color(0xFFcecece);


  static LinearGradient bottomShadow = LinearGradient(colors: [Color(0xFF107873).withOpacity(0.2), Color(0xFF107873).withOpacity(0)], begin: Alignment.bottomCenter, end: Alignment.topCenter);
  static LinearGradient linearBlackBottom = LinearGradient(colors: [Colors.black.withOpacity(0.45), Colors.black.withOpacity(0)], begin: Alignment.bottomCenter, end: Alignment.topCenter);
  static LinearGradient linearBlackTop = LinearGradient(colors: [Colors.black.withOpacity(0.5), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter);
}