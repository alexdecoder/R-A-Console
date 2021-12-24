import 'package:flutter/material.dart';
import 'package:ra_console/models/contact_requests.dart';
import 'package:ra_console/pages/home/website_manipulation/view_contact_request.dart';
import 'package:ra_console/services/data_view_builder.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/themes/palette.dart';

class ContactRequestsDetailView extends StatelessWidget {
  final SimpleHttp http;
  ContactRequestsDetailView(this.http);

  @override
  Widget build(BuildContext context) {
    return DataViewBuilder(
      title: 'Contact Requests',
      tail: 'api/q/site/contact_requests/',
      http: http,
      query: '',
      builder: (Map response) {
        Map data = response['value'];

        return Column(
          children: data.entries
              .map((MapEntry e) => ContactRequestNode(
                    http,
                    request: ContactRequest(
                        firstName: e.value['first_name'],
                        lastName: e.value['last_name'],
                        date: e.value['date'],
                        email: e.value['email'],
                        number: e.value['phone'],
                        uuid: e.key,
                        request: e.value['details']),
                  ))
              .toList(),
        );
      },
    );
  }
}

class ContactRequestNode extends StatelessWidget {
  final SimpleHttp http;
  final ContactRequest request;
  ContactRequestNode(this.http, {required this.request});

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
                  child: Icon(Icons.mail_outline,
                      size: 27.0, color: ColorPalette.blueColor),
                  decoration: BoxDecoration(
                    color: ColorPalette.blueColor.withOpacity(.5),
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
                    ),
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
