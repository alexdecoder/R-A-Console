import 'dart:convert';
import 'package:ra_console/models/contact_requests.dart';
import 'package:ra_console/models/customers.dart';
import 'package:ra_console/models/general_info.dart';
import 'package:ra_console/models/issued_cards.dart';
import 'package:ra_console/models/recent_activity.dart';
import 'package:ra_console/models/services.dart';
import 'package:ra_console/utils/cacheing_provider.dart';
import 'package:ra_console/widgets/labeled_section.dart';

class DataParser {
  static Future<void> initializeDatasets(String payload) async {
    var _buffer = json.decode(payload)['value'];

    CacheingProvider provider = CacheingProvider();
    await provider.initialize();
    Map<dynamic, dynamic> _customerData = _buffer['customers'] ?? {};
    customers = _customerData.entries
        .map((MapEntry e) => Customer(
              name: e.value['name'],
              balance: e.value['balance'],
              phoneNumber: e.value['phoneNumber'],
              uuid: e.key,
            ))
        .toList();
    Map<dynamic, dynamic> _cardData = _buffer['cards'] ?? {};
    issuedCards = _cardData.entries
        .map(
          (MapEntry e) => IssuedCard(
            cardholder: e.value['cardHolder'],
            expMonth: e.value['expMonth'],
            expYear: e.value['expYear'],
            lastFour: e.value['last4'],
            group: getRandomGradient(),
          ),
        )
        .toList();

    Map<dynamic, dynamic> _general = _buffer['general'] ?? {};
    firstName = _general['first_name'] ?? '';
    previousSeven = _general['prev7rev'] ?? 0.0;
    payoutTotal = _general['payout'] ?? 0.0;
    issuingTotal = _general['issuing'] ?? 0.0;

    Map<dynamic, dynamic> _recentServices = _buffer['recentServices'] ?? {};
    recentServices = _recentServices.entries
        .map(
          (MapEntry e) => ServiceNode(
            iconId: e.value['iconId'],
            name: e.value['name'],
            date: e.value['date'],
            amount: e.value['amount'],
            title: e.value['title'],
            uuid: e.key,
          ),
        )
        .toList();

    Map<dynamic, dynamic> _recentAccountEvents =
        _buffer['account']?['accountBalanceEvents'] ?? {};
    recentAccountActivityEvents = _recentAccountEvents.entries
        .map(
          (MapEntry e) => AccountEvent(
            wasTransferedIn: e.value['wasTransferedIn'],
            date: e.value['date'],
            amount: e.value['amount'],
          ),
        )
        .toList();

    Map<dynamic, dynamic> _recentIssuingEvents =
        _buffer['account']?['issuingEvents'] ?? {};
    recentIssuingEvents = _recentIssuingEvents.entries
        .map(
          (MapEntry e) => IssuingEvent(
              lastFour: e.value['last4'],
              authorized: e.value['authorized'],
              cardHolder: e.value['cardholder'],
              date: e.value['date'],
              amount: e.value['amount'],
              title: e.value['title'],
              id: e.key),
        )
        .toList();

    Map<dynamic, dynamic> _contactRequests = _buffer['contactRequests'] ?? {};
    contactRequests = _contactRequests.entries
        .map(
          (MapEntry e) => ContactRequest(
              firstName: e.value['first_name'],
              lastName: e.value['last_name'],
              date: e.value['date'],
              email: e.value['email'],
              number: e.value['phone'],
              request: e.value['details'],
              uuid: e.key),
        )
        .toList();
  }
}
