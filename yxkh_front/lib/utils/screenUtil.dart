import 'package:flutter/material.dart';
import 'dart:ui' as ui;
class ScreenUtils {
  double _screenWidth = 0.0;
  double _screenHeight = 0.0;
  MediaQueryData _mediaQueryData;

  static final ScreenUtils _singleton = ScreenUtils();

  static ScreenUtils getInstance() {
    _singleton._init();
    return _singleton;
  }
   _init() {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    if (_mediaQueryData != mediaQuery) {
      _mediaQueryData = mediaQuery;
    }
  }
    /// screen width
  /// 屏幕 宽
  double get screenWidth => _screenWidth;

  /// screen height
  /// 屏幕 高
  double get screenHeight => _screenHeight;

    /// screen width
  /// 当前屏幕 宽
  static double screenW(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width;
  }

  /// screen height
  /// 当前屏幕 高
  static double screenH(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height;
  }
  // 获取sliver grid元素宽高比
  static double getChildAspectRatio(double fixedHeight,double currentWidth){
    return currentWidth/fixedHeight;
  }
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800 &&
        MediaQuery.of(context).size.width < 1200;
  }
}