import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ra_console/routers/main_router.dart';
import 'package:ra_console/themes/dark_theme.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://7f4a8ebf0bae440ea754fd7b2c55c036@o201842.ingest.sentry.io/5666076';
      },
      // Init your App.
      appRunner: () => runApp(RAConsole()),
    );
  } else {
    runApp(RAConsole());
  }
}

class RAConsole extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => MainRouter(),
      },
      theme: RATheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
