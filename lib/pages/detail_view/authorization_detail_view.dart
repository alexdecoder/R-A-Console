import 'package:flutter/material.dart';
import 'package:ra_console/models/issued_cards.dart';
import 'package:ra_console/pages/detail_view/recent_service_detail_view.dart';
import 'package:ra_console/services/data_view_builder.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/pages/home/home_pages/revenue_dart.dart';
import 'package:ra_console/themes/palette.dart';
import 'package:ra_console/widgets/labeled_section.dart';

class AuthorizationDetailView extends StatelessWidget {
  final SimpleHttp http;
  final String id;
  AuthorizationDetailView(this.http, this.id);

  @override
  Widget build(BuildContext context) {
    return DataViewBuilder(
      title: 'Card Authorization',
      query: id,
      tail: 'api/q/cards/authorization/',
      http: http,
      builder: (Map response) {
        Map data = response['value'];

        String? wallet;

        switch (data['wallet']) {
          case 'apple_pay':
            wallet = 'Apple Pay';
            break;
          case 'google_pay':
            wallet = 'Google Pay';
            break;
          case 'samsung_pay':
            wallet = 'Samsung Pay';
            break;
          case 'amazon_pay':
            wallet = 'Amazon Pay';
            break;
        }

        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
              child: CardNode(
                  IssuedCard(
                      cardholder: data['name'],
                      expMonth: data['expMonth'],
                      expYear: data['expYear'],
                      lastFour: data['last4'],
                      group: getRandomGradient()),
                  overridePadding: true),
            ),
            LabeledSection(
              label: 'Charge Details',
              nodes: <Widget>[
                SeperatedSection(
                  children: <Widget>[
                    _DetailNode(
                      title: 'Amount',
                      detail: '\$' + data['amount'].toStringAsFixed(2),
                      icon: Icons.attach_money,
                      color: Theme.of(context).primaryColor,
                    ),
                    _DetailNode(
                      title: data['approved']
                          ? 'Transaction was authorized'
                          : 'Transaction was denied',
                      detail: '',
                      icon: data['approved'] ? Icons.check : Icons.close,
                      color: data['approved']
                          ? Theme.of(context).primaryColor
                          : ColorPalette.redColor,
                    ),
                    _DetailNode(
                      title: 'Method',
                      detail: data['method'],
                      icon: Icons.credit_card,
                      color: ColorPalette.purpleColor,
                    ),
                    if (data['wallet'] != null)
                      _DetailNode(
                        title: 'Digital Wallet',
                        detail: wallet!,
                        icon: Icons.phone_android,
                        color: ColorPalette.redColor,
                      )
                  ],
                ),
              ],
            ),
            LabeledSection(
              label: 'Merchant Details',
              nodes: <Widget>[
                SeperatedSection(
                  children: <Widget>[
                    _DetailNode(
                      title: 'Merchant Name',
                      detail: data['merchant'],
                      icon: Icons.storefront,
                      color: ColorPalette.blueColor,
                    ),
                    _DetailNode(
                      title: 'Merchant Location',
                      detail: data['city'],
                      icon: Icons.place,
                      color: ColorPalette.orangeColor,
                    ),
                    _DetailNode(
                      title: 'Merchant Category',
                      detail: data['category'],
                      icon: Icons.inbox,
                      color: ColorPalette.purpleColor,
                    )
                  ],
                )
              ],
            )
          ],
        );
      },
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
