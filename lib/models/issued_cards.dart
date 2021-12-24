import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ra_console/themes/palette.dart';

class IssuedCard {
  final int expYear;
  final int expMonth;
  final String lastFour;
  final String cardholder;
  final GradientGroup group;
  IssuedCard(
      {required this.cardholder,
      required this.expMonth,
      required this.expYear,
      required this.lastFour,
      required this.group});
}

class GradientGroup {
  final Color color1;
  final Color color2;
  GradientGroup(this.color1, this.color2);
}

List<GradientGroup> _gradientGroups = <GradientGroup>[
  GradientGroup(ColorPalette.blueColor, ColorPalette.redColor),
  GradientGroup(ColorPalette.purpleColor, ColorPalette.blueColor),
  GradientGroup(Color(0xff75fab2), ColorPalette.blueColor),
  GradientGroup(Color(0xff75fab2), ColorPalette.purpleColor),
  GradientGroup(Color(0xff75fab2), ColorPalette.orangeColor),
  GradientGroup(ColorPalette.blueColor, ColorPalette.orangeColor),
  GradientGroup(ColorPalette.redColor, ColorPalette.purpleColor),
];

final _random = new Random();
int _next(int min, int max) => min + _random.nextInt(max - min);
GradientGroup getRandomGradient() =>
    _gradientGroups[_next(0, _gradientGroups.length)];

List<IssuedCard> issuedCards = [];
