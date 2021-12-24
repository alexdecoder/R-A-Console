import 'package:flutter/material.dart';
import 'package:ra_console/pages/detail_view/recent_service_detail_view.dart';
import 'package:ra_console/services/data_view_builder.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/themes/palette.dart';
import 'package:ra_console/widgets/labeled_section.dart';
import 'package:ra_console/widgets/overview/quick_action_buttons.dart';

class CustomerDetailView extends StatelessWidget {
  final String? uuid;
  final SimpleHttp http;
  CustomerDetailView(this.uuid, this.http);

  @override
  Widget build(BuildContext context) {
    return DataViewBuilder(
      title: 'Client Info',
      builder: (Map response) {
        Map data = response['value'];
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Row(
                children: <Widget>[
                  QuickAction(
                    text: 'New Job',
                    color: ColorPalette.redColor,
                    icon: Icons.handyman,
                  ),
                  QuickAction(
                    text: 'Message',
                    color: Theme.of(context).primaryColor,
                    icon: Icons.send_outlined,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
            ),
            LabeledSection(
              label: 'Client Info',
              nodes: <Widget>[
                SeperatedSection(
                  children: <Widget>[
                    _DetailNode(
                      title: 'Name',
                      detail: data['name'],
                      icon: Icons.label_outline,
                      color: ColorPalette.blueColor,
                    ),
                    _DetailNode(
                      title: 'Total account balance',
                      detail: '\$' + data['tab'].toStringAsFixed(2),
                      icon: Icons.attach_money,
                      color: Theme.of(context).primaryColor,
                    ),
                    _DetailNode(
                      title: 'Address',
                      detail: data['address'],
                      icon: Icons.home_outlined,
                      color: ColorPalette.orangeColor,
                    ),
                    _DetailNode(
                      title: 'Phone Number',
                      detail: data['phone'],
                      icon: Icons.phone_outlined,
                      color: ColorPalette.purpleColor,
                    ),
                    _DetailNode(
                      title: 'Email Address',
                      detail: data['email'],
                      icon: Icons.alternate_email,
                      color: ColorPalette.redColor,
                    ),
                  ],
                )
              ],
            ),
            LabeledSection(
              label: 'All Services',
              nodes: <Widget>[
                SeperatedSection(
                  overridePadding: true,
                  children: data['services']
                      .entries
                      .map<Widget>(
                        (MapEntry e) => ServiceNode(
                          title: e.value['title'],
                          name: '',
                          date: e.value['date'],
                          amount: e.value['amount'],
                          iconId: e.value['icon'],
                          uuid: e.key,
                          overrideRightPadding: 15.0,
                          http: http,
                          canNavigateToClient: false,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ],
        );
      },
      query: uuid!,
      tail: 'api/q/cust/',
      http: http,
    );
  }
}

class _DetailNode extends StatelessWidget {
  final String title;
  final String detail;
  final IconData icon;
  final Color color;
  _DetailNode(
      {required this.title,
      required this.detail,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          _DetailIcon(color: color, icon: icon),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  if (detail != '')
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          detail,
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 10.0),
    );
  }
}

class _DetailIcon extends StatelessWidget {
  final Color color;
  final IconData icon;
  _DetailIcon({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
