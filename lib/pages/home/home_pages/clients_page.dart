import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ra_console/models/customers.dart';
import 'package:ra_console/pages/detail_view/customer_detail_view.dart';
import 'package:ra_console/pages/home/home_controller.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/widgets/clients/client_header.dart';
import 'package:ra_console/widgets/home/data_wrapper.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Customer>? _buffer = customers;

  bool isSearching = false;

  void search(String query, BuildContext context) async {
    setState(() => isSearching = true);
    DataWrapper.of(context)!
        .data
        .request(
            method: true,
            tail: 'api/q/search/',
            body: jsonEncode({'query': query}))
        .then((SimpleHttpResponseObject resp) {
      if (resp.success) {
        Map payload = jsonDecode(resp.response);
        if (payload['result'] == 'success') {
          List<Customer>? updatedBuffer = payload['value']
              .entries
              .map<Customer>((MapEntry e) => Customer(
                  name: e.value['name'],
                  balance: e.value['tab'],
                  phoneNumber: e.value['phone'],
                  uuid: e.key))
              .toList();

          setState(() {
            _buffer = updatedBuffer;
            isSearching = false;
          });
        } else {
          setState(() => isSearching = false);
        }
      } else {
        setState(() => isSearching = false);
      }
    });
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClientHeader(
            textChangedCallback: (String query) => search(query, context),
            isSearching: isSearching),
        Expanded(
          child: ClipRRect(
            child: Container(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: ReloadCallbackWrapper.of(context)!.callback,
                child: ListView.builder(
                  itemBuilder: (_, int index) => ClientNode(_buffer![index]),
                  itemCount: _buffer!.length,
                ),
              ),
              color: Theme.of(context).cardColor,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
        ),
      ],
    );
  }
}

class ClientNode extends StatelessWidget {
  final Customer customer;
  ClientNode(this.customer);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CustomerDetailView(
                customer.uuid, DataWrapper.of(context)!.data))),
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.person,
                  size: 27.0,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.5),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(10.0),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        customer.name,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          customer.phoneNumber,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white60),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
              Text(
                '\$' + customer.balance.toStringAsFixed(2),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0,
                ),
              )
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
      ),
    );
  }
}
