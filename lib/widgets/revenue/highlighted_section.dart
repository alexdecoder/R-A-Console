import 'package:flutter/material.dart';
import 'package:ra_console/models/recent_activity.dart';
import 'package:ra_console/pages/detail_view/authorization_detail_view.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/themes/palette.dart';

class HighlightedSection extends StatelessWidget {
  final String label;
  final List<Widget> nodes;
  HighlightedSection({required this.label, required this.nodes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 13.0, left: 15.0),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: Colors.white70,
                ),
              ),
            ),
            ...nodes,
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(
            30.0,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 15.0),
      ),
    );
  }
}

class HighlightedSectionNode extends StatelessWidget {
  final bool wasTransferedIn;
  final double amount;
  final String date;
  HighlightedSectionNode(
      {required this.wasTransferedIn,
      required this.amount,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Container(
              child: Icon(
                wasTransferedIn ? Icons.login : Icons.logout,
                size: 27.0,
                color: wasTransferedIn
                    ? Theme.of(context).primaryColor
                    : ColorPalette.redColor,
              ),
              decoration: BoxDecoration(
                color: (wasTransferedIn
                        ? Theme.of(context).primaryColor
                        : ColorPalette.redColor)
                    .withOpacity(.5),
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: EdgeInsets.all(10.0),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      wasTransferedIn ? 'Bank ➔ Balance' : 'Balance ➔ Bank',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      amount < 0
                          ? '-\$' + amount.abs().toStringAsFixed(2)
                          : '\$' + amount.toStringAsFixed(2),
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
    );
  }
}

class IssuingEventNode extends StatelessWidget {
  final IssuingEvent event;
  final SimpleHttp http;
  IssuingEventNode(this.http, {required this.event});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AuthorizationDetailView(http, event.id))),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Container(
                  child: Icon(
                    event.authorized ? Icons.check : Icons.close,
                    size: 27.0,
                    color: event.authorized
                        ? Theme.of(context).primaryColor
                        : ColorPalette.redColor,
                  ),
                  decoration: BoxDecoration(
                    color: (event.authorized
                            ? Theme.of(context).primaryColor
                            : ColorPalette.redColor)
                        .withOpacity(.5),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            event.title,
                            style: TextStyle(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '-\$' + event.amount.abs().toStringAsFixed(2),
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
                            event.date,
                            style: TextStyle(color: Colors.white60),
                          ),
                          Text(
                            event.cardHolder + ' • ' + event.lastFour,
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
