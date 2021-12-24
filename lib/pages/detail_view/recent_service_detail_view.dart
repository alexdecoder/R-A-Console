import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ra_console/pages/detail_view/customer_detail_view.dart';
import 'package:ra_console/services/data_view_builder.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/themes/palette.dart';
import 'package:ra_console/widgets/home/ui_elements.dart';
import 'package:ra_console/widgets/labeled_section.dart';
import 'package:ra_console/widgets/overview/quick_action_buttons.dart';

class RecentServiceDetailView extends StatefulWidget {
  final String uuid;
  final SimpleHttp http;
  final bool? canNavigateToClient;
  RecentServiceDetailView(this.uuid, this.http, this.canNavigateToClient);

  @override
  _RecentServiceDetailViewState createState() =>
      _RecentServiceDetailViewState();
}

class _RecentServiceDetailViewState extends State<RecentServiceDetailView> {
  bool _jobNotesFieldSubmitEnabled = true;

  TextEditingController? controller;
  bool isInitialBuild = true;
  String? initialText;

  Future<bool> _updateJobNotes() async {
    Completer<bool> completer = Completer<bool>();

    await widget.http
        .request(
            method: true,
            tail: 'api/q/job/update/',
            body: jsonEncode(
                {'job_uuid': widget.uuid, 'notes': controller!.text}))
        .then((SimpleHttpResponseObject response) {
      if (response.success) {
        Map data = jsonDecode(response.response);
        if (data['result'] == 'success') {
          completer.complete(true);
        } else {
          completer.complete(false);
        }
      } else {
        completer.complete(false);
      }
    }).catchError((_) {
      completer.complete(false);
    });

    return completer.future;
  }

  Future<bool> _handleClosureActions(BuildContext context) async {
    if (controller!.text != initialText) {
      FocusScope.of(context)
          .unfocus(); // Prevent glitchy keyboard appearance by dismissing it
      return await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Close without saving notes?'),
          actions: <Widget>[
            TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false)),
            ElevatedButton(
                child: Text('Close'),
                onPressed: () => Navigator.of(context).pop(true)),
          ],
        ),
      );
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: DataViewBuilder(
        http: widget.http,
        tail: 'api/q/job/',
        query: widget.uuid,
        title: 'Job Details',
        overridePopAction: () async {
          if (await (_handleClosureActions(context))) {
            Navigator.of(context).pop();
          }
        },
        builder: (Map response) {
          Map data = response['value'];
          if (isInitialBuild) {
            controller = TextEditingController(text: data['jobNotes']);
            isInitialBuild = false;
            initialText = data['jobNotes'];
          }

          return Column(
            children: <Widget>[
              if (!data['isPaid'])
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Row(
                    children: <Widget>[
                      /* // Maybe some day...
                    QuickAction(
                      text: 'Edit',
                      color: ColorPalette.blueColor,
                      icon: Icons.edit_outlined,
                    ),
                    */
                      QuickAction(
                        text: 'QR Code',
                        color: ColorPalette.orangeColor,
                        icon: Icons.qr_code,
                      ),
                      QuickAction(
                        text: 'Remind',
                        color: ColorPalette.purpleColor,
                        icon: Icons.history,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  ),
                ),
              LabeledSection(
                label: 'Client Info',
                nodes: <Widget>[
                  SeperatedSection(
                    children: <Widget>[
                      _DetailNode(
                        title: 'Name',
                        detail: data['name'],
                        icon: Icons.label_outline,
                        color: ColorPalette.blueColor,
                      ),
                      _DetailNode(
                        title: 'Total account balance',
                        detail: '\$' + data['balance'].toStringAsFixed(2),
                        icon: Icons.attach_money,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  if (widget.canNavigateToClient ?? true)
                    Padding(
                      padding:
                          EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                      child: LargeButton('View Client',
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => CustomerDetailView(
                                    data['cust_uuid'], widget.http),
                              ))),
                    ),
                ],
              ),
              LabeledSection(
                label: 'Job Info',
                nodes: <Widget>[
                  SeperatedSection(
                    children: <Widget>[
                      _DetailNode(
                        title: 'Job Title',
                        detail: data['title'],
                        icon: Icons.label_outline,
                        color: ColorPalette.orangeColor,
                      ),
                      _DetailNode(
                        title: 'ID',
                        detail: data['uuid'],
                        icon: Icons.tag,
                        color: ColorPalette.purpleColor,
                      ),
                      _DetailNode(
                        title: 'Cost',
                        detail: '\$' + data['cost'].toStringAsFixed(2),
                        icon: Icons.attach_money,
                        color: Theme.of(context).primaryColor,
                      ),
                      _DetailNode(
                        title: 'Date',
                        detail: data['date'],
                        icon: Icons.calendar_today_outlined,
                        color: ColorPalette.blueColor,
                      ),
                      _DetailNode(
                        title: data['isPaid']
                            ? 'Job is paid off'
                            : 'Job has not been paid off',
                        detail: '',
                        icon: data['isPaid'] ? Icons.check : Icons.close,
                        color: data['isPaid']
                            ? Theme.of(context).primaryColor
                            : ColorPalette.redColor,
                      ),
                    ],
                  ),
                ],
              ),
              LabeledSection(
                label: 'Job Notes',
                nodes: <Widget>[
                  SeperatedSection(
                    children: <Widget>[
                      TextField(
                        controller: controller,
                        onChanged: (String value) {
                          if (value != data['jobNotes']) {
                            if (_jobNotesFieldSubmitEnabled) {
                              setState(
                                  () => _jobNotesFieldSubmitEnabled = false);
                            }
                          } else {
                            if (!_jobNotesFieldSubmitEnabled) {
                              setState(
                                  () => _jobNotesFieldSubmitEnabled = true);
                            }
                          }
                        },
                        minLines: 10,
                        maxLines: 10,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                          hintText: 'Enter job notes here...',
                        ),
                        autocorrect: true,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                child: LargeButton('Save', onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() => _jobNotesFieldSubmitEnabled = true);
                  // Implement the http request
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => StatefulBuilder(
                      builder: (BuildContext context, Function setState) {
                        bool canDismiss = false;
                        bool isLoading = true;

                        _updateJobNotes().then((bool result) {
                          if (result) {
                            initialText = controller!.text;

                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              canDismiss = true;
                              isLoading = false;
                            });
                          }
                        });

                        final List<Widget> errorWidgets = <Widget>[
                          Text('There was an error uploading your job notes.'),
                          Row(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Dismiss'),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.end,
                          ),
                        ];
                        return WillPopScope(
                          child: Dialog(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  if (isLoading) CircularProgressIndicator(),
                                  if (!isLoading) ...errorWidgets,
                                ],
                                mainAxisSize: MainAxisSize.min,
                              ),
                              color: Theme.of(context).cardColor,
                              padding: EdgeInsets.all(20.0),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          ),
                          onWillPop: () async => canDismiss,
                        );
                      },
                    ),
                  );
                }, disabled: _jobNotesFieldSubmitEnabled),
              ),
            ],
          );
        },
      ),
      onWillPop: (() async => await _handleClosureActions(context)),
    );
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }
}

class SeperatedSection extends StatelessWidget {
  final List<Widget> children;
  final bool? overridePadding;
  SeperatedSection({required this.children, this.overridePadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: ClipRRect(
        child: Container(
          child: Column(children: children),
          color: Theme.of(context).cardColor,
          padding: overridePadding == null || !overridePadding!
              ? EdgeInsets.all(15)
              : EdgeInsets.symmetric(vertical: 15.0),
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
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
