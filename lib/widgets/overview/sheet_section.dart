import 'package:flutter/material.dart';
import 'package:ra_console/models/services.dart';
import 'package:ra_console/widgets/home/ui_elements.dart';
import 'package:ra_console/widgets/labeled_section.dart';

class SheetSection extends StatelessWidget {
  final ScrollController controller;
  SheetSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      children: <Widget>[
        LabeledSection(label: 'Recent Services', nodes: recentServices),
        if (recentServices.length == 20) LargeButton('View all', onTap: () {}),
      ],
    );
  }
}
