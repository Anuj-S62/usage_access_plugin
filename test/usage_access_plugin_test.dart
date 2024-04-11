import 'package:flutter_test/flutter_test.dart';
import 'package:usage_access_plugin/usage_access_plugin.dart';
import 'package:usage_access_plugin/usage_access_plugin_platform_interface.dart';
import 'package:usage_access_plugin/usage_access_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUsageAccessPluginPlatform
    with MockPlatformInterfaceMixin
    implements UsageAccessPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final UsageAccessPluginPlatform initialPlatform = UsageAccessPluginPlatform.instance;

  test('$MethodChannelUsageAccessPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUsageAccessPlugin>());
  });

  test('getPlatformVersion', () async {
    UsageAccessPlugin usageAccessPlugin = UsageAccessPlugin();
    MockUsageAccessPluginPlatform fakePlatform = MockUsageAccessPluginPlatform();
    UsageAccessPluginPlatform.instance = fakePlatform;

    expect(await usageAccessPlugin.getPlatformVersion(), '42');
  });
}
