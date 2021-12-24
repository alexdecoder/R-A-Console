import 'package:flutter/material.dart';
import 'package:ra_console/models/recent_activity.dart';
import 'package:ra_console/services/data_view_builder.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/widgets/revenue/highlighted_section.dart';

class CardActivityDetailView extends StatelessWidget {
  final SimpleHttp http;
  CardActivityDetailView(this.http);

  @override
  Widget build(BuildContext context) {
    return DataViewBuilder(
      title: 'Card Activity',
      tail: 'api/q/cards/activity/',
      http: http,
      query: '',
      builder: (Map response) {
        Map data = response['value'];

        return Column(
          children: data.entries
              .map((MapEntry e) => IssuingEventNode(http,
                  event: IssuingEvent(
                    lastFour: e.value['last4'],
                    authorized: e.value['authorized'],
                    cardHolder: e.value['cardholder'],
                    date: e.value['date'],
                    amount: e.value['amount'],
                    title: e.value['title'],
                    id: e.key,
                  )))
              .toList(),
        );
      },
    );
  }
}
