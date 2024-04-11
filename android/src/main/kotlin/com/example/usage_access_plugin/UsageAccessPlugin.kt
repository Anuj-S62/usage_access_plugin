package com.example.usage_access_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.provider.Settings
import java.util.Calendar

import androidx.annotation.NonNull
import android.net.Uri

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware



import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.app.usage.UsageStatsManager
import android.app.usage.UsageEvents
import android.content.ContextWrapper
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.app.AppOpsManager
import android.app.usage.UsageStats
import android.os.Build
import android.util.Log
/** UsageAccessPlugin */
class UsageAccessPlugin: FlutterPlugin, MethodCallHandler,ActivityAware{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private val methodChannelName = "usage_access.methodChannel"
  private lateinit var activity: Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannelName)
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.applicationContext;
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "checkUsageAccessPermission" -> {
        val granted = checkUsageAccessPermission()
        result.success(granted)
      }
      "requestUsageAccessPermission" -> {
        requestUsageAccessPermission()
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }



  private fun checkUsageAccessPermission(): Boolean {
    val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
    val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      appOps.unsafeCheckOpRaw(
        AppOpsManager.OPSTR_GET_USAGE_STATS,
        android.os.Process.myUid(), context.packageName
      )
    } else {
      appOps.checkOpNoThrow(
        AppOpsManager.OPSTR_GET_USAGE_STATS,
        android.os.Process.myUid(), context.packageName
      )
    }
    return mode == AppOpsManager.MODE_ALLOWED
  }

  private fun requestUsageAccessPermission() {
    val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent.data = Uri.parse("package:${context.packageName}")
    context.startActivity(intent)
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.activity = binding.activity
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

}
