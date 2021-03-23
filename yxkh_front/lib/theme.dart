import 'package:flutter/material.dart';

class DashboardTheme {
  // 登陆界面,由浅蓝至深蓝
  static LinearGradient primaryGradient = LinearGradient(
    colors: const [Color.fromRGBO(0, 160, 192, 1), Color.fromRGBO(0, 71, 129, 1)],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static TextStyle menuListTileDefaultText =
      TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle menuListTileSelectedText = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle cardTileSubText = TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal);
  static TextStyle cardTileTitleText = TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal);
  static TextStyle cardTileMainText = TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold);
  static TextStyle cardTitleTextStyle = TextStyle(fontSize: 18, color: Colors.black87);
  static Color selectedColor = Color(0xFF4AC8EA);
  static Color drawerBgColor = Color(0xFF272D34);
  static double appBarHeight = 55;
  static BoxConstraints boxConstraints = BoxConstraints(minHeight: 40, maxHeight: 200);
  static BoxDecoration leftBoxDecoration = BoxDecoration(
      border: Border(
    left: BorderSide(
      color: Colors.grey,
      width: 2,
    ),
  ));
  static BoxDecoration lrtBoxDecoration = BoxDecoration(
      border: Border(
    top: BorderSide(
      color: Colors.grey,
      width: 2,
    ),
    left: BorderSide(
      color: Colors.grey,
      width: 2,
    ),
    right: BorderSide(
      color: Colors.grey,
      width: 2,
    ),
  ));
  static BoxDecoration allBoxDecoration = BoxDecoration(
      border: Border(
    top: BorderSide(
      color: Colors.grey,
      width: 2,
    ),
    left: BorderSide(
      color: Colors.grey,
      width: 2,
    ),
    right: BorderSide(
      color: Colors.grey,
      width: 2,
    ),
    bottom: BorderSide(
      color: Colors.grey,
      width: 2,
    ),
  ));
  static BoxDecoration allRedBoxDecoration = BoxDecoration(
      border: Border(
    top: BorderSide(
      color: Colors.red,
      width: 2,
    ),
    left: BorderSide(
      color: Colors.red,
      width: 2,
    ),
    right: BorderSide(
      color: Colors.red,
      width: 2,
    ),
    bottom: BorderSide(
      color: Colors.red,
      width: 2,
    ),
  ));
  static BoxDecoration rightBoxDecoration = BoxDecoration(
      border: Border(
    right: BorderSide(
      color: Colors.grey,
      width: 2,
    ),
  ));
  static TextStyle formTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
}
