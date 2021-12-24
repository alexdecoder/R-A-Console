import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ra_console/pages/home/basic_page.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/widgets/account_manipulation.dart/onboarding_widgets.dart';
import 'package:ra_console/widgets/home/ui_elements.dart';
import 'package:ra_console/widgets/labeled_section.dart';
import 'package:ra_console/widgets/revenue/highlighted_section.dart';

class OnboardingPage extends StatefulWidget {
  final Function reloadCallback;
  final SimpleHttp http;
  OnboardingPage(this.reloadCallback, this.http);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? emptyValidator(String? value) {
    return value == null || value.isEmpty
        ? 'This field cannot be empty.'
        : null;
  }

  final RegExp _emailValidator = RegExp(
    r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$',
    caseSensitive: false,
    multiLine: false,
  );

  final RegExp _phoneValidator = RegExp(
      r'^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$',
      caseSensitive: false,
      multiLine: false);

  final Map<String, String> _fieldData = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BasicPage(
        title: 'Onboarding',
        children: <Widget>[
          Disclaimer(),
          LabeledSection(
            label: 'Client Information',
            nodes: <Widget>[
              HighlightedSection(
                label: 'General Info',
                nodes: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 5.0),
                    child: Column(
                      children: <Widget>[
                        OnboardingInputField(
                          title: 'First Name',
                          validator: emptyValidator,
                          onSaved: (String? value) {
                            _fieldData['first_name'] = value!;
                          },
                        ),
                        OnboardingInputField(
                            title: 'Last Name',
                            validator: emptyValidator,
                            onSaved: (String? value) {
                              _fieldData['last_name'] = value!;
                            })
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: HighlightedSection(
                  label: 'Contact Info',
                  nodes: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 5.0),
                      child: Column(
                        children: <Widget>[
                          OnboardingInputField(
                              title: 'Email',
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field cannot be empty.';
                                } else if (!_emailValidator.hasMatch(value)) {
                                  return 'Invalid email address.';
                                }
                              },
                              onSaved: (String? value) {
                                _fieldData['email'] = value!;
                              }),
                          OnboardingInputField(
                              title: 'Phone Number',
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field cannot be empty.';
                                } else if (!_phoneValidator.hasMatch(value)) {
                                  return 'Invalid phone number.';
                                }
                              },
                              onSaved: (String? value) {
                                _fieldData['number'] = value!;
                              }),
                          OnboardingInputField(
                              title: 'Address',
                              validator: emptyValidator,
                              onSaved: (String? value) {
                                _fieldData['address'] = value!;
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                child: LargeButton('Create User', onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    widget.http
                        .request(
                            method: true,
                            tail: 'api/q/cust/create/',
                            body: jsonEncode(_fieldData))
                        .then((SimpleHttpResponseObject value) async {
                      await widget.reloadCallback();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (_) => false);
                    });

                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => WillPopScope(
                        child: Dialog(
                          elevation: 0,
                          backgroundColor: Theme.of(context).backgroundColor,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                child: CircularProgressIndicator(),
                                padding: EdgeInsets.all(20.0),
                              ),
                            ],
                          ),
                        ),
                        onWillPop: () async => true,
                      ),
                    );
                  }
                }),
              )
            ],
          ),
        ],
      ),
    );
  }
}
