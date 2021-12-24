import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/widgets/home/ui_elements.dart';

class DataViewBuilder extends StatefulWidget {
  final String title;
  final Widget Function(Map) builder;
  final String tail;
  final String query;
  final SimpleHttp http;
  final Function? overridePopAction;
  DataViewBuilder(
      {required this.title,
      required this.builder,
      required this.query,
      required this.tail,
      required this.http,
      this.overridePopAction});

  @override
  _DataViewBuilderState createState() => _DataViewBuilderState();
}

class _DataViewBuilderState extends State<DataViewBuilder> {
  bool isLoading = true;
  bool initialBuild = true;
  bool requestDidFail = false;
  bool wasServerError = false;

  late BuildContext _context;

  Map responseData = Map();
  void createRequest({bool? shouldResetLayout}) {
    if (shouldResetLayout ?? false) {
      setState(() {
        isLoading = true;
        requestDidFail = false;
        wasServerError = false;
      });
    }

    widget.http
        .request(
            method: true,
            tail: widget.tail,
            body: jsonEncode({'query': widget.query}))
        .then(
      (value) {
        if (value.success) {
          try {
            responseData = jsonDecode(value.response);
            if (responseData['result'] != 'error') {
              setState(() => isLoading = false);
            } else {
              requestDidFail = true;
              wasServerError = true;

              showDialog(
                context: _context,
                barrierDismissible: false,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    'There was a server error during your request. Please try again later.',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .popUntil(ModalRoute.withName('/')),
                      child: Text('Dismiss'),
                    ),
                  ],
                ),
              );
            }
          } on Exception catch (_) {
            setState(() {
              requestDidFail = true;
              isLoading = false;
            });
          }
        } else {
          setState(() {
            requestDidFail = true;
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (initialBuild) {
      createRequest();
      initialBuild = false;
      _context = context;
    }

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
                      onTap: () => widget.overridePopAction != null
                          ? widget.overridePopAction!()
                          : Navigator.of(context).pop(),
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
                            widget.title,
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
            Visibility(child: LinearProgressIndicator(), visible: isLoading),
            Visibility(
              visible: requestDidFail && !wasServerError,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(
                            Icons.cloud_off,
                            color: Colors.white60,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'Network error. Check your network connection.',
                            style: TextStyle(
                              color: Colors.white60,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                    color: Theme.of(context).cardColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
                    child: LargeButton(
                      'Retry',
                      onTap: () => createRequest(shouldResetLayout: true),
                    ),
                  )
                ],
              ),
            ),
            if (!isLoading && !requestDidFail)
              Expanded(
                child: SingleChildScrollView(
                  child: widget.builder(responseData),
                ),
              ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
