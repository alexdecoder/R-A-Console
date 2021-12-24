import 'package:flutter/material.dart';
import 'package:ra_console/models/services.dart';
import 'package:ra_console/pages/detail_view/recent_service_detail_view.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/widgets/home/data_wrapper.dart';

class LabeledSection extends StatelessWidget {
  final String label;
  final List<Widget> nodes;
  LabeledSection({required this.label, required this.nodes});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 17.0, left: 20.0, right: 20.0),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Colors.white70,
              ),
            ),
          ),
          ...nodes
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 30.0),
      width: MediaQuery.of(context).size.width,
    );
  }
}

class ServiceNode extends StatelessWidget {
  final int iconId;
  final double amount;
  final String title;
  final String date;
  final String name;
  final String uuid;
  final double? overrideRightPadding;
  final SimpleHttp? http;
  final bool? canNavigateToClient;
  ServiceNode({
    required this.title,
    required this.name,
    required this.date,
    required this.amount,
    required this.iconId,
    required this.uuid,
    this.overrideRightPadding,
    this.http,
    this.canNavigateToClient,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => RecentServiceDetailView(uuid,
                http ?? DataWrapper.of(context)?.data, canNavigateToClient))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: overrideRightPadding ?? 20.0),
                child: _ServiceIcon(
                    color: iconId != -1
                        ? ServiceIconThemes.themes[iconId + 1].color
                        : ServiceIconThemes.themes[0].color,
                    icon: iconId != -1
                        ? ServiceIconThemes.themes[iconId + 1].icon
                        : ServiceIconThemes.themes[0].icon),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '\$' + amount.toStringAsFixed(2),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            date,
                            style: TextStyle(color: Colors.white60),
                          ),
                          Text(
                            name,
                            style: TextStyle(color: Colors.white60),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  final Color color;
  final IconData icon;
  _ServiceIcon({required this.color, required this.icon});

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
