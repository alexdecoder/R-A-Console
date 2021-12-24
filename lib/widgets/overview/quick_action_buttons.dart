import 'package:flutter/material.dart';
import 'package:ra_console/pages/home/account_manipulation_pages/onboarding.dart';
import 'package:ra_console/pages/home/home_controller.dart';
import 'package:ra_console/pages/home/website_manipulation/website.dart';
import 'package:ra_console/themes/palette.dart';
import 'package:ra_console/widgets/home/data_wrapper.dart';

class QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        QuickAction(
          text: 'New Job',
          color: ColorPalette.blueColor,
          icon: Icons.handyman,
        ),
        QuickAction(
          text: 'New Event',
          color: ColorPalette.purpleColor,
          icon: Icons.event_rounded,
        ),
        QuickAction(
          text: 'Website',
          color: ColorPalette.orangeColor,
          icon: Icons.web,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  WebsiteManagement(DataWrapper.of(context)!.data))),
        ),
        QuickAction(
          text: 'Onboarding',
          color: Theme.of(context).primaryColor,
          icon: Icons.person_add,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => OnboardingPage(
                  ReloadCallbackWrapper.of(context)!.callback,
                  DataWrapper.of(context)!.data))),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }
}

class QuickAction extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final void Function()? onTap;
  QuickAction(
      {required this.text,
      required this.color,
      required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            child: Icon(
              icon,
              size: 27.0,
              color: color,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(.5),
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: EdgeInsets.all(10.0),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(.5),
                fontSize: 11.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
