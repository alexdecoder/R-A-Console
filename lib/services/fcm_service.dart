import 'dart:async';
import 'package:flutter/services.dart';

class FcmService {
  final String _channelName = 'com.syncronosys.ra_console/fcm';
  late MethodChannel _platform;

  FcmService() {
    _platform = MethodChannel(_channelName);
  }

  Future<String?> getFirebaseToken() async {
    try {
      final String? result = await _platform.invokeMethod('getFCMtoken');
      return result;
    } on PlatformException {
      return null;
    }
  }

  Future<void> setupNotificationChannels() async {
    // Per Android SDK docs, it is safe to run this at the start of the app (once per run)
    // because creating new channels with old data does nothing
    await _platform.invokeMethod('setupNotificationChannels');
  }
}
