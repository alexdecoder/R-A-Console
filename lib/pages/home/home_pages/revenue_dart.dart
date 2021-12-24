import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ra_console/models/general_info.dart';
import 'package:ra_console/models/issued_cards.dart';
import 'package:ra_console/models/recent_activity.dart';
import 'package:ra_console/pages/detail_view/card_activity_detail_view.dart';
import 'package:ra_console/pages/home/home_controller.dart';
import 'package:ra_console/widgets/home/data_wrapper.dart';
import 'package:ra_console/widgets/home/ui_elements.dart';
import 'package:ra_console/widgets/labeled_section.dart';
import 'package:ra_console/widgets/revenue/highlighted_section.dart';
import 'package:ra_console/widgets/revenue/payout_dialog.dart';

class RevenuePage extends StatefulWidget {
  final Function refreshDataCallback;
  RevenuePage(this.refreshDataCallback);

  @override
  _RevenuePageState createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'Revenue & Issued Cards',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: ReloadCallbackWrapper.of(context)!.callback,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CardCarousel(),
                  AmountSection(),
                  HighlightedSection(
                    label: 'Recent account activity',
                    nodes: recentAccountActivityEvents
                        .asMap()
                        .entries
                        .map(
                          (MapEntry e) => HighlightedSectionNode(
                            wasTransferedIn: e.value.wasTransferedIn,
                            amount: e.value.amount,
                            date: e.value.date,
                          ),
                        )
                        .toList(),
                  ),
                  if (payoutTotal! > 0)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: LargeButton(
                        'Payout balance',
                        onTap: () => showDialog(
                            context: context,
                            builder: (_) => PayoutDialog(
                                DataWrapper.of(context)!.data,
                                widget.refreshDataCallback)),
                      ),
                    ),
                  IssuedCardsBalanceSection(),
                  HighlightedSection(
                    label: 'Recent activity on issued cards',
                    nodes: <Widget>[
                      ...recentIssuingEvents
                          .asMap()
                          .entries
                          .map((MapEntry e) => IssuingEventNode(
                              DataWrapper.of(context)!.data,
                              event: e.value))
                          .toList(),
                      if (recentIssuingEvents.length == 5)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => CardActivityDetailView(
                                          DataWrapper.of(context)!.data))),
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: LargeButton(
                      'Top off cards',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class IssuedCardsBalanceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LabeledSection(
      label: 'Available on issued cards',
      nodes: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '\$' + issuingTotal!.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 50.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AmountSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LabeledSection(
      label: 'Available for payout',
      nodes: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '\$' + payoutTotal!.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 50.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardCarousel extends StatelessWidget {
  final PageController _controller = PageController(viewportFraction: .9);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.0),
      child: Container(
        child: PageView.builder(
            controller: _controller,
            itemCount: issuedCards.length,
            itemBuilder: (BuildContext context, int index) =>
                CardNode(issuedCards[index])),
        width: MediaQuery.of(context).size.width,
        height: 200.0,
      ),
    );
  }
}

class CardNode extends StatelessWidget {
  final IssuedCard card;
  final bool? overridePadding;
  CardNode(this.card, {this.overridePadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: overridePadding ?? false ? 0 : 20.0),
      child: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.ccVisa, size: 35.0),
                      Icon(Icons.arrow_forward)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        card.cardholder,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          '•••• ' + card.lastFour,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white60,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          (card.expMonth.toString().length == 1
                                  ? '0' + card.expMonth.toString()
                                  : card.expMonth.toString()) +
                              '/' +
                              card.expYear.toString().substring(2, 4),
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [card.group.color1, card.group.color2],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 200.0,
      ),
    );
  }
}
