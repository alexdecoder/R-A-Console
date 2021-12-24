import 'package:flutter/material.dart';
import 'package:ra_console/models/contact_requests.dart';
import 'package:ra_console/pages/detail_view/recent_service_detail_view.dart';
import 'package:ra_console/themes/palette.dart';
import 'package:ra_console/widgets/labeled_section.dart';

class ViewContactRequestPage extends StatelessWidget {
  final ContactRequest request;
  ViewContactRequestPage(this.request);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back, size: 30.0),
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 38.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'View Contact Request',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    LabeledSection(
                      label: 'Requester Information',
                      nodes: <Widget>[
                        SeperatedSection(
                          children: <Widget>[
                            _DetailNode(
                              title: 'Name',
                              detail:
                                  request.firstName + ' ' + request.lastName,
                              icon: Icons.label_outline,
                              color: ColorPalette.blueColor,
                            ),
                            _DetailNode(
                              title: 'Date',
                              detail: request.date,
                              icon: Icons.calendar_today_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            _DetailNode(
                              title: 'Phone Number',
                              detail: request.number,
                              icon: Icons.phone_outlined,
                              color: ColorPalette.purpleColor,
                            ),
                            _DetailNode(
                              title: 'Email Address',
                              detail: request.email,
                              icon: Icons.alternate_email,
                              color: ColorPalette.redColor,
                            ),
                          ],
                        )
                      ],
                    ),
                    LabeledSection(
                      label: 'Request details',
                      nodes: <Widget>[
                        SeperatedSection(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    request.request,
                                    style: TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
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
