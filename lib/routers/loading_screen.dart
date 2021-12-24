import 'package:flutter/material.dart';
import 'package:ra_console/utils/sys_colors.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageLayout.setUIColors(Colors.transparent, Brightness.light,
        Theme.of(context).backgroundColor, Brightness.light);
    return Scaffold(
      body: Center(
          child: Image.asset('lib/assets/images/logo.png', height: 35.0)),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
