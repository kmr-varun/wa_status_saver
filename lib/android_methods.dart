import 'package:flutter/services.dart';

abstract class AndroidMethods {
  static const platform = MethodChannel('thundrai.in/statussaver');

  static Future<String> getAndroidVersion() async {
    return await platform.invokeMethod("getAndroidVersion");
  }

  static Future<bool> sendMediaScannerBroadcast(String path) async {
    return await platform.invokeMethod("sendMediaScannerBroadcast", path);
  }
}
