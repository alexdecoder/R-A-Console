import 'package:flutter/material.dart';
import 'package:ra_console/models/contact_requests.dart';
import 'package:ra_console/pages/home/basic_page.dart';
import 'package:ra_console/pages/home/website_manipulation/contact_requests.dart';
import 'package:ra_console/pages/home/website_manipulation/view_contact_request.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/widgets/labeled_section.dart';
import 'package:ra_console/widgets/revenue/highlighted_section.dart';

class WebsiteManagement extends StatelessWidget {
  final SimpleHttp http;
  WebsiteManagement(this.http);

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      title: 'Website Management',
      children: <Widget>[
        LabeledSection(
          label: 'Contact Requests',
          nodes: <Widget>[
            HighlightedSection(
              label: 'Last five contact requests',
              nodes: <Widget>[
                ...contactRequests
                    .take(5)
                    .toList()
                    .asMap()
                    .entries
                    .map(
                      (MapEntry e) => ContactRequestNode(e.value),
                    )
                    .toList(),
                if (contactRequests.length > 5)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ContactRequestsDetailView(http))),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'View All',
                              style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 19.0,
                                color: Colors.white60,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class ContactRequestNode extends StatelessWidget {
  final ContactRequest request;
  ContactRequestNode(this.request);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ViewContactRequestPage(request))),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Container(
                  child: Icon(
                    Icons.person,
                    size: 27.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.5),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      request.firstName + ' ' + request.lastName,
                      style: TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        request.date,
                        style: TextStyle(color: Colors.white60),
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
