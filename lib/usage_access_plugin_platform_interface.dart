import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'usage_access_plugin_method_channel.dart';

abstract class UsageAccessPluginPlatform extends PlatformInterface {
  /// Constructs a UsageAccessPluginPlatform.
  UsageAccessPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static UsageAccessPluginPlatform _instance = MethodChannelUsageAccessPlugin();

  /// The default instance of [UsageAccessPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelUsageAccessPlugin].
  static UsageAccessPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UsageAccessPluginPlatform] when
  /// they register themselves.
  static set instance(UsageAccessPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
