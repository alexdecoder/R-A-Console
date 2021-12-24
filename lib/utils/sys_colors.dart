import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class PageLayout {
  static void setUIColors(final Color topBar, final Brightness topBarBrightness,
      final Color navBar, final Brightness navBarBrightness) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: navBar,
      statusBarColor: topBar,
      systemNavigationBarIconBrightness: navBarBrightness,
      statusBarBrightness: topBarBrightness,
      statusBarIconBrightness: topBarBrightness,
    ));
  }
}
