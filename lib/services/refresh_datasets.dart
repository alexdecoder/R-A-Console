import 'dart:async';

import 'package:ra_console/services/data_parser.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:ra_console/utils/cacheing_provider.dart';

class RefreshDatasets {
  static Future<void> refresh(SimpleHttp http, Function errorCallback) async {
    Completer<void> _completer = Completer<void>();
    http.request(
      method: false,
      tail: 'api/',
      callback: (int status, bool success, String data) async {
        if (success) {
          CacheingProvider provider = CacheingProvider();
          await provider.initialize();

          await DataParser.initializeDatasets(data);

          await provider.writeCacheToDisk(data);

          _completer.complete();
        } else {
          errorCallback();

          _completer.complete();
        }
      },
    );

    return _completer.future;
  }
}
