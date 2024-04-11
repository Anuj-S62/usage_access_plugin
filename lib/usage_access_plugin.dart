
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

import 'usage_access_plugin_platform_interface.dart';


class UsageAccessPluginException implements Exception {
  String _cause;

  UsageAccessPluginException(this._cause);

  @override
  String toString() => _cause;
}

class UsageAccessInfo {
  late bool isUsageAccessGranted;

  UsageAccessInfo(bool isUsageAccessGranted) {
    this.isUsageAccessGranted = isUsageAccessGranted;
  }

  bool getIsUsageAccessGranted() {
    return isUsageAccessGranted;
  }

}


class UsageAccess{
  static const MethodChannel _channel = MethodChannel('usage_access.methodChannel');

  static final UsageAccess _instance = UsageAccess._();
  UsageAccess._();
  factory UsageAccess() => _instance;
  Future<UsageAccessInfo> getUsageAccessInfo() async {
    try {
      final bool isUsageAccessGranted = await _channel.invokeMethod('checkUsageAccessPermission');
      return UsageAccessInfo(isUsageAccessGranted);
    } on PlatformException catch (e) {
      throw UsageAccessPluginException(e.message!);
    }
  }
  Future<void> requestUsageAccessPermission() async {
    try {
      await _channel.invokeMethod('requestUsageAccessPermission');
    } on PlatformException catch (e) {
      throw UsageAccessPluginException(e.message!);
    }
  }

}




