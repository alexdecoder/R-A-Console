import 'dart:async';
import 'dart:convert';

import 'package:ra_console/services/fcm_service.dart';
import 'package:ra_console/services/simplehttp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountInitialization {
  SimpleHttp? _http;
  AccountInitialization(SimpleHttp? http) : _http = http;

  Future<bool> handshake({String? username, String? password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');

    Completer completer = Completer<bool>();

    Map<dynamic, dynamic> body;

    FcmService service = FcmService();
    if (id != null) {
      body = {'established_id': id, 'token': await service.getFirebaseToken()};
    } else {
      body = {
        'username': username,
        'password': password,
        'token': await service.getFirebaseToken()
      };
    }

    _http!
        .request(
            method: true,
            tail: 'api/handshake/',
            body: jsonEncode(body),
            verbose: true)
        .then(
      (SimpleHttpResponseObject object) {
        if (object.success) {
          Map<dynamic, dynamic> response = jsonDecode(object.response);
          if (response['result'] == 'success') {
            prefs.setString('id', response['id']);

            completer.complete(true);
          } else if (response['value'] != 'invalid_credentials') {
            completer.completeError(Exception('server_error'));
          } else {
            completer.complete(false);
          }
        } else {
          if (object.httpStatus == 0) {
            completer.completeError(Exception('timed_out'));
          } else {
            completer.completeError(Exception('server_error'));
          }
        }
      },
    );

    return completer.future as Future<bool>;
  }

  Future<bool> tokenExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id') != null;
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');

    print('Cleared authenticaiton token');
  }
}
