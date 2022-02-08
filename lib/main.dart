import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void main() => runApp(MyApp());

const simpleTaskKey = "simpleTask";
const rescheduledTaskKey = "rescheduledTask";
const failedTaskKey = "failedTask";
const simpleDelayedTask = "simpleDelayedTask";
const simplePeriodicTask = "simplePeriodicTask";
const simplePeriodic1HourTask = "simplePeriodic1HourTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Future.delayed(Duration(seconds: 20));
    showNotification();
    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum _Platform { android, ios }

class PlatformEnabledButton extends ElevatedButton {
  final _Platform platform;

  PlatformEnabledButton({
    required this.platform,
    required Widget child,
    required VoidCallback onPressed,
  }) : super(
      child: child,
      onPressed: (Platform.isAndroid && platform == _Platform.android ||
          Platform.isIOS && platform == _Platform.ios)
          ? onPressed
          : null);
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    Workmanager().initialize(
      callbackDispatcher,
      // isInDebugMode: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter WorkManager Example"),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('start background service'),
            onPressed: (){
              Workmanager().registerOneOffTask('1', 'simpleTask');
            },
          ),
        )
      ),
    );
  }
}


Future showNotification() async {
  // await Duration(seconds: 5);
  late FlutterLocalNotificationsPlugin fltrNotification;

  var androidInitilize = const AndroidInitializationSettings('icon');
  var iOSinitilize =  const IOSInitializationSettings();
  var initilizationsSettings = InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
  fltrNotification =  FlutterLocalNotificationsPlugin();
  fltrNotification.initialize(initilizationsSettings);

  var androidDetails = const AndroidNotificationDetails(
      "Channel ID", "Desi programmer", "This is my channel",
      importance: Importance.max);
  var iSODetails = const IOSNotificationDetails();
  var generalNotificationDetails =
  NotificationDetails(android: androidDetails, iOS: iSODetails);
  await fltrNotification.show(
      0, "Task", "You created a Task",
      generalNotificationDetails);
}