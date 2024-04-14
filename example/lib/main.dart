import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:usage_access_plugin/usage_access_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _packageName = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  void getPackageName() async {
    late bool per;
    try {
      UsageAccessInfo temp = await UsageAccess().getUsageAccessInfo();
      per = temp.getScreenStatus();
      // print(temp.isScreenOn);
      // print(temp.isUsageAccessGranted);
    } on PlatformException {
      per = false;
    }
    if (!mounted) return;

    setState(() {
      _packageName = per.toString();
    });
  }

  void requestPermission()async{
    UsageAccessInfo temp = await UsageAccess().getUsageAccessInfo();
    UsageAccess().requestUsageAccessPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                requestPermission();
              },
            ),
          ],
        ),
        body: Center(
          child: Text('Running App: $_packageName\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            getPackageName();
          },
          child: const Icon(Icons.add),
        ),
      ),
      //  add a floating action button

    );
  }
}
