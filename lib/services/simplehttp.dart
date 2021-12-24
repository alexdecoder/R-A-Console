/*
  Created by Alex Rankin on 8/2/2020
  Updated: 8/3/2020
  Version: 1.0.2
  Contributer(s): Alex Rankin

  (C) 2020 Syncronosys
  https://syncronosys.com/
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class SimpleHttpResponseObject {
  final int httpStatus;
  final String response;
  final bool success;

  /// Response object from a SimpleHttp request.
  SimpleHttpResponseObject(this.httpStatus, this.response, this.success);
}

class SimpleHttp {
  // Private declarations
  String _baseUrl;
  Map<String, String> headers = {};

  final Function authErrorCallback;

  List<String> _httpCookieParameters = [
    'expires',
    'max-age',
    'domain',
    'path',
    'secure',
    'httponly',
    'samesite'
  ];

  void _updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      List<String> index = rawCookie.split(';');
      if (index.length > 0) {
        String buffer = '';
        for (var item in index) {
          if (item.indexOf('=') > 0) {
            if (!_httpCookieParameters
                .contains(item.substring(1, item.indexOf('=')).toLowerCase())) {
              // Fixes some odd behavior of cloudflare where 'sessionid' cookie is overridden as 'Secure,sessionid'
              if (item.substring(1, item.indexOf('=')).toLowerCase() ==
                  'secure,sessionid') {
                buffer += 'sessionid' +
                    item.substring(item.indexOf('='), item.length);
              } else {
                buffer = buffer + item + ';';
              }
            }
          }
        }
        headers['cookie'] = buffer;
      }
    }
  }

  void _conditionalPrint(bool verbose, String string) {
    if (verbose) {
      print(string);
    }
  }

  /// Url that all requests on this object will access
  SimpleHttp(String baseUrl, Function callback)
      : this._baseUrl = baseUrl,
        this.authErrorCallback = callback;

  ///Create a new web request
  ///method: if true = **POST** request false = **GET** request.
  ///tail: the path to your external resourse. This is where you also put GET parameters.
  ///body: http body data. Put any data here that you will need on your backend here in JSON form.
  ///preserveCookies: use this if you want this request to obey your backend's SET_COOKIE parameters. **true by default**
  ///verbose: use this to log actions to the console. this is primarily for debugging and is off by default.
  ///callback: the function that is called after your request is either successful or after it fails. This is primarily used to update the interface. Three parameters are passed to the callback and they are as follows:
  ///  * **(int) HTTP status code** (200, 400, 500, 404, etc).
  ///  * **(bool) success** whether or not the request failed.
  ///  * **(String) response body** the text returned from the webserver.

  Future<SimpleHttpResponseObject> request({
    required bool method,
    required String tail,
    String body = '',
    bool? preserveCookies,
    bool? verbose,
    Function(int, bool, String)? callback,
  }) async {
    Completer<SimpleHttpResponseObject> _completer =
        Completer<SimpleHttpResponseObject>();
    http.Response _response;

    if (method) {
      try {
        _response = await http
            .post(Uri.https(_baseUrl, tail), headers: headers, body: body)
            .timeout(Duration(seconds: 5))
            .catchError((e) {
          if (callback != null) {
            callback(0, false, '');
          }
          _completer.complete(SimpleHttpResponseObject(0, '', false));
        });
      } on TimeoutException catch (_) {
        if (callback != null) {
          callback(408, false, '');
        }

        _completer.complete(SimpleHttpResponseObject(408, '', false));
      } catch (_) {
        if (callback != null) {
          callback(0, false, '');
        }

        _completer.complete(SimpleHttpResponseObject(0, '', false));
      }

    }

    return _completer.future;
    /*
    verbose = true; // FORCE VERBOSE

    Completer<SimpleHttpResponseObject> _completer =
        Completer<SimpleHttpResponseObject>();

    if (method) {
      _conditionalPrint(
          verbose == true, 'Sending POST request to: ' + _baseUrl + tail);
      http.Response response;
      _conditionalPrint(verbose == true && body != '', 'Body set to: ' + body);
      try {
        response = await http
            .post(Uri.https(_baseUrl, tail), headers: headers, body: body)
            .timeout(Duration(seconds: 5))
            .catchError((e) {
          if (callback != null) {
            callback(0, false, '');
          }
          _completer.complete(SimpleHttpResponseObject(0, '', false));
        });

        try {
          Map jsonData = jsonDecode(response.body);
          if (jsonData['result'] == 'error' &&
              jsonData['value'] == 'invalid_credentials') {
            authErrorCallback();
          }
        } on Exception {}
      } on TimeoutException catch (_) {
        _conditionalPrint(verbose == true, 'Request timed out.');

        if (callback != null) {
          callback(408, false, '');
        }

        return SimpleHttpResponseObject(408, '', false);
      } on Exception {
        _conditionalPrint(verbose == true, 'Request failed.');

        if (callback != null) {
          callback(0, false, '');
        }

        return SimpleHttpResponseObject(0, '', false);
      }

      _conditionalPrint(
          verbose == true,
          'Response received: ' +
              response.body +
              ' with status code: ' +
              response.statusCode.toString());
      _conditionalPrint(
          verbose == true && preserveCookies == true, 'Updating headers');

      if (preserveCookies == null) {
        _updateCookie(response);
      } else {
        if (preserveCookies == true) {
          _updateCookie(response);
        }
      }

      try {
        _conditionalPrint(
            verbose == true, 'Cookie header is set to: ' + headers['cookie']!);
      } catch (_) {}

      _conditionalPrint(
          verbose == true && callback != null, 'Running callback');
      if (callback != null) {
        callback(
            response.statusCode, response.statusCode == 200, response.body);
      }

      return SimpleHttpResponseObject(
          response.statusCode, response.body, response.statusCode == 200);
    } else {
      if (body != '') {
        throw Exception(
            'The body paramater cannot be used with a GET request. Change the method to "true" to use this.');
      }

      _conditionalPrint(
          verbose == true, 'Sending GET request to: ' + _baseUrl + tail);

      http.Response response;
      try {
        response = await http
            .get(Uri.https(_baseUrl, tail), headers: headers)
            .timeout(Duration(seconds: 5));
      } on TimeoutException catch (_) {
        _conditionalPrint(verbose == true, 'Request timed out.');

        if (callback != null) {
          callback(408, false, '');
        }

        return SimpleHttpResponseObject(408, '', false);
      } on Exception catch (_) {
        _conditionalPrint(verbose == true, 'Request failed.');

        if (callback != null) {
          callback(0, false, '');
        }

        return SimpleHttpResponseObject(0, '', false);
      }

      _conditionalPrint(
          verbose == true,
          'Response received: ' +
              response.body +
              ' with status code: ' +
              response.statusCode.toString());
      _conditionalPrint(
          verbose == true && preserveCookies == true, 'Updating headers');

      if (preserveCookies == null) {
        _updateCookie(response);
      } else {
        if (preserveCookies == true) {
          _updateCookie(response);
        }
      }

      try {
        _conditionalPrint(
            verbose == true, 'Cookie header is set to: ' + headers['cookie']!);
      } catch (_) {}

      _conditionalPrint(
          verbose == true && callback != null, 'Running callback');
      if (callback != null) {
        callback(
            response.statusCode, response.statusCode == 200, response.body);
      }

      return SimpleHttpResponseObject(
          response.statusCode, response.body, response.statusCode == 200);
    }

    return _completer.future;
    */
  }

  /// Set custom HTTP header.
  void setCustomHeader(String key, String value) => headers[key] = value;

  /// Release all HTTP headers **INCLUDING** cookies set by the webserver.
  void releaseHttpHeaders() => headers = {};

  /// Returns all headers currently set.
  Map<String, String> pullHeaders() {
    return headers;
  }

  /// Replaces the current headers with a specified one.
  void setHeaders(Map<String, String> headerSet) => headers = headerSet;
}
