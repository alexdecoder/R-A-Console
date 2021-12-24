import 'package:flutter/material.dart';
import 'package:ra_console/pages/home/home_controller.dart';
import 'package:ra_console/pages/login/login_page.dart';
import 'package:ra_console/routers/error_screen.dart';
import 'package:ra_console/routers/loading_screen.dart';
import 'package:ra_console/services/account_initialization.dart';
import 'package:ra_console/services/data_parser.dart';
import 'package:ra_console/services/fcm_service.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/utils/cacheing_provider.dart';
import 'package:ra_console/widgets/home/data_wrapper.dart';

class MainRouter extends StatefulWidget {
  @override
  _MainRouterState createState() => _MainRouterState();
}

class _MainRouterState extends State<MainRouter> {
  Widget currentView = LoadingScreen();

  CacheingProvider provider = CacheingProvider();

  bool mustInitialize = false;

  bool hasBuilt = false;

  late AccountInitialization init;

  void startupActions() async {
    FcmService fcm = FcmService();
    await fcm.setupNotificationChannels();

    if (await init.tokenExists()) {
      await provider.initialize();
      if (await provider.cacheDoesExist()) {
        await provider.readCacheToMemory();
      } else {
        finalizeInitialization();
        mustInitialize = true;
      }

      if (!mustInitialize) {
        setState(() => currentView = HomeController(startupActions));
      }
    } else {
      setState(() => currentView = LoginPage(startupActions));
    }
  }

  void _writeCache(String payload) async {
    await provider.initialize();
    await provider.writeCacheToDisk(payload);
    await DataParser.initializeDatasets(payload);

    setState(() => currentView = HomeController(startupActions));
  }

  void finalizeInitialization() async {
    overviewRequest!.request(
      method: false,
      tail: 'api/',
      callback: (int status, bool success, String data) {
        if (!success) {
          setState(() => currentView = ErrorScreen());
        } else {
          _writeCache(data);
        }
      },
    );
  }

  SimpleHttp? overviewRequest;
  @override
  Widget build(BuildContext context) {
    if (!hasBuilt) {
      overviewRequest = SimpleHttp('e1c2-65-185-52-51.ngrok.io', () async {
        // Set the application url here (why I did it this way, I don't know)
        AccountInitialization init = AccountInitialization(overviewRequest);
        await init.clearToken();
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
        setState(() => currentView = LoginPage(startupActions));
      });
      init = AccountInitialization(overviewRequest);
      startupActions();
      hasBuilt = true;
    }

    return WillPopScope(
      child: AnimatedSwitcher(
        child: DataWrapper(data: overviewRequest, child: currentView),
        duration: Duration(milliseconds: 250),
      ),
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Are you sure you want to quit?'),
                actions: <Widget>[
                  TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false)),
                  ElevatedButton(
                      child: Text('Close'),
                      onPressed: () => Navigator.of(context).pop(true)),
                ],
              ),
            ) ??
            false;
      },
    );
  }
}
