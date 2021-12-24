import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ra_console/themes/palette.dart';
import 'package:ra_console/widgets/labeled_section.dart';

class IconTheme {
  final Color color;
  final IconData icon;

  IconTheme(this.color, this.icon);
}

class ServiceIconThemes {
  static List<IconTheme> themes = [
    IconTheme(Colors.white, FontAwesomeIcons.question), // -1: Other
    IconTheme(ColorPalette.blueColor, FontAwesomeIcons.cut), // 0: Trimming
    IconTheme(ColorPalette.orangeColor,
        FontAwesomeIcons.seedling), // 1: Plant services
    IconTheme(ColorPalette.purpleColor,
        FontAwesomeIcons.car), // 2: Automotive services
    IconTheme(
        ColorPalette.redColor, FontAwesomeIcons.tint), // 3: Irrigation Services
  ];
}

List<ServiceNode> recentServices = [];
