import 'package:flutter/material.dart';
import 'package:ra_console/pages/home/home_controller.dart';
import 'package:ra_console/widgets/overview/header_section.dart';
import 'package:ra_console/widgets/overview/quick_action_buttons.dart';
import 'package:ra_console/widgets/overview/sheet_section.dart';

class OverviewPage extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SizedBox(
              height: constraints.maxHeight * .45,
              child: Column(
                children: <Widget>[
                  OverviewHeaderSection(),
                  QuickActions(),
                ],
              ),
            ),
            DraggableScrollableSheet(
              minChildSize:
                  (constraints.maxHeight * .55) / constraints.maxHeight,
              initialChildSize:
                  (constraints.maxHeight * .55) / constraints.maxHeight,
              builder: (BuildContext context, ScrollController controller) =>
                  ClipRRect(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: ReloadCallbackWrapper.of(context)!.callback,
                  child: Container(
                    child: SheetSection(controller: controller),
                    color: Theme.of(context).cardColor,
                  ),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
