import 'package:flutter/material.dart';
import 'package:ra_console/services/account_initialization.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/themes/palette.dart';
import 'package:ra_console/utils/sys_colors.dart';
import 'package:ra_console/widgets/home/data_wrapper.dart';
import 'package:ra_console/widgets/home/ui_elements.dart';

class LoginPage extends StatefulWidget {
  final Function callback;
  LoginPage(this.callback);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool progressIndicator = false;

  bool firstBuild = true;
  SimpleHttp? http;

  String error = '';

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  void auth() {
    setState(() => progressIndicator = true);

    AccountInitialization init = AccountInitialization(http);
    init
        .handshake(username: username.text, password: password.text)
        .then((value) {
      if (value) {
        widget.callback();
      } else {
        setState(() {
          progressIndicator = false;
          error = 'Incorrect username or password.';
        });
      }
    }).catchError((e) {
      setState(() {
        progressIndicator = false;
        error = 'Could not connect to servers. Check your network connection.';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      PageLayout.setUIColors(Colors.transparent, Brightness.light,
          Theme.of(context).backgroundColor, Brightness.light);

      http = DataWrapper.of(context)!.data;

      firstBuild = false;
    }
    final node = FocusScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Opacity(
                child: LinearProgressIndicator(),
                opacity: progressIndicator ? 1.0 : 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.lock,
                            size: 45.0,
                          ),
                          padding: EdgeInsets.all(17.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(62.0)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 25.0),
                          child: Align(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Welcome back!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    'Sign into an existing account.',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            TextField(
                              controller: username,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: TextStyle(fontSize: 17.0),
                              textInputAction: TextInputAction.next,
                              cursorColor: Theme.of(context).primaryColor,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: TextField(
                                controller: password,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: TextStyle(fontSize: 17.0),
                                cursorColor: Theme.of(context).primaryColor,
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () => node.unfocus(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
                              child: LargeButton(
                                'Login',
                                onTap: () {
                                  node.unfocus();
                                  if (username.text != '' &&
                                      password.text != '') {
                                    auth();
                                  } else {
                                    setState(() =>
                                        error = 'Please fill out all fields.');
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                error,
                                style: TextStyle(color: ColorPalette.redColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Image.asset('lib/assets/images/logo.png', height: 25.0),
              )
            ],
          ),
          width: MediaQuery.of(context).size.width,
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
