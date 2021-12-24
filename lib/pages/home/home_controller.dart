import 'package:flutter/material.dart';
import 'package:ra_console/pages/home/home_pages/clients_page.dart';
import 'package:ra_console/pages/home/home_pages/overview_page.dart';
import 'package:ra_console/pages/home/home_pages/revenue_dart.dart';
import 'package:ra_console/pages/home/home_pages/schedule_page.dart';
import 'package:ra_console/services/account_initialization.dart';
import 'package:ra_console/services/data_parser.dart';
import 'package:ra_console/services/refresh_datasets.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/utils/cacheing_provider.dart';
import 'package:ra_console/utils/sys_colors.dart';
import 'package:ra_console/widgets/home/bottom_navigation_bar.dart';
import 'package:ra_console/widgets/home/data_wrapper.dart';

class HomeController extends StatefulWidget {
  final Function callback;
  HomeController(this.callback);

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  int _pageOverride = 0;

  bool isInitialBuild = true;
  SimpleHttp? overviewRequest;
  SimpleHttpResponseObject? responseObject;

  PageController _controller = PageController();

  CacheingProvider _cacheingProvider = CacheingProvider();

  bool requestDidFail = false;

  bool isShowingProgressIndicator = true;

  void _pageChangeCallback(int index) {
    _controller.animateToPage(index,
        duration: Duration(milliseconds: 250), curve: Curves.ease);
  }

  void _writeCache(String payload) async {
    await _cacheingProvider.initialize();
    await _cacheingProvider.writeCacheToDisk(payload);
  }

  void _initializeUser() async {
    AccountInitialization init = AccountInitialization(overviewRequest);
    bool auth = await init.handshake().catchError((_) {
      setState(() => requestDidFail = true);
      return false;
    });
    if (auth) {
      await overviewRequest!.request(
        method: false,
        tail: 'api/',
        callback: (int status, bool success, String data) async {
          if (success) {
            requestDidFail = false;
            await DataParser.initializeDatasets(data);
            _writeCache(data);
          } else {
            requestDidFail = true;
          }

          setState(() => isShowingProgressIndicator = false);
        },
      );
    } else {
      await init.clearToken();
      widget.callback();
    }
  }

  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final GlobalKey keystack = GlobalKey();
  @override
  Widget build(BuildContext context) {
    PageLayout.setUIColors(
        Colors.transparent,
        Theme.of(context).brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        Theme.of(context).cardColor,
        Theme.of(context).brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light);

    overviewRequest = DataWrapper.of(context)!.data;
    if (isInitialBuild) {
      _initializeUser();

      isInitialBuild = false;
    }

    return ReloadCallbackWrapper(
      child: Scaffold(
        key: _key,
        backgroundColor: Theme.of(context).backgroundColor,
        body: KeyedSubtree(
          key: keystack,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Opacity(
                  child: LinearProgressIndicator(),
                  opacity: isShowingProgressIndicator ? 1 : 0,
                ),
                Visibility(
                  visible: requestDidFail,
                  child: Container(
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
                            'Network error. Showing previously fetched results.',
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
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (value) {
                      FocusScope.of(context).unfocus();
                      setState(() => _pageOverride = value);
                    },
                    children: <Widget>[
                      OverviewPage(),
                      ClientsPage(),
                      RevenuePage(() {
                        setState(() => isShowingProgressIndicator = true);
                        _initializeUser();
                      }),
                      SchedulePage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar:
            BottomNavBar(_pageChangeCallback, pageOverride: _pageOverride),
      ),
      callback: () async {
        await RefreshDatasets.refresh(
            overviewRequest!, () => setState(() => requestDidFail = true));

        setState(() => requestDidFail = false);
      },
    );
  }
}

class ReloadCallbackWrapper extends InheritedWidget {
  final Future<void> Function() callback;
  ReloadCallbackWrapper({Key? key, required child, required this.callback})
      : super(child: child, key: key);

  static ReloadCallbackWrapper? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ReloadCallbackWrapper>();

  @override
  bool updateShouldNotify(_) => false;
}
