import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ra_console/models/general_info.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/themes/palette.dart';
import 'package:ra_console/widgets/home/ui_elements.dart';

class PayoutDialog extends StatefulWidget {
  final SimpleHttp http;
  final Function refreshDataCallback;
  PayoutDialog(this.http, this.refreshDataCallback);

  @override
  _PayoutDialogState createState() => _PayoutDialogState();
}

class _PayoutDialogState extends State<PayoutDialog> {
  String errorDialog = '';
  bool isDisabled = true;

  bool isLoading = false;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Dialog(
        child: Column(
          children: <Widget>[
            Opacity(
                child: LinearProgressIndicator(), opacity: isLoading ? 1.0 : 0),
            Container(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Payout to bank',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Transfer funds from your account balance to your bank account balance.',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          '\$' + payoutTotal!.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 27.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'available for payout.',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: Text('\$')),
                        Container(
                            child: TextField(
                              controller: controller,
                              cursorColor: Theme.of(context).primaryColor,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 2.0),
                                isDense: true,
                              ),
                              onChanged: (String value) {
                                if (double.tryParse(value) == null) {
                                  setState(() {
                                    errorDialog = 'Invalid number';
                                    isDisabled = true;
                                  });
                                } else if (double.tryParse(value)! >
                                    payoutTotal!) {
                                  setState(() {
                                    errorDialog =
                                        'Input is greater than available total';
                                    isDisabled = true;
                                  });
                                } else {
                                  setState(() {
                                    errorDialog = '';
                                    isDisabled = false;
                                  });
                                }
                              },
                            ),
                            width: 75.0),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      child: Text(
                        errorDialog,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: ColorPalette.redColor,
                        ),
                      ),
                      constraints: BoxConstraints(minHeight: 17.5),
                    ),
                  ),
                  LargeButton(
                    'Payout',
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isDisabled = true;
                        isLoading = true;
                      });
                      widget.http
                          .request(
                              method: true,
                              verbose: true,
                              tail: 'api/q/balance/payout/',
                              body: jsonEncode(
                                  {'payout': double.parse(controller.text)}))
                          .then((SimpleHttpResponseObject response) {
                        if (response.success) {
                          Map data = jsonDecode(response.response);
                          if (data['result'] == 'success') {
                            widget.refreshDataCallback();

                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              isLoading = false;
                              errorDialog =
                                  'There was an error processing your request';
                            });
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                            errorDialog =
                                'There was an error processing your request';
                          });
                        }
                      });
                    },
                    disabled: isDisabled,
                  )
                ],
              ),
              padding: EdgeInsets.all(20.0),
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      onWillPop: () async => !isLoading,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
