import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'LocalNotificationService.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void printHello(service) async {
  String localTimeZone =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      notificationLayout: NotificationLayout.BigText,
      channelKey: 'basic_channel',
      title: 'Simple Notification',
      body: 'Simple body',
      wakeUpScreen: true,
      fullScreenIntent: true,
      criticalAlert: true,
    ),
    schedule: NotificationInterval(
      interval: 10,
      timeZone: localTimeZone,
      preciseAlarm: true,
    ),
    actionButtons: <NotificationActionButton>[
      NotificationActionButton(key: 'yes', label: 'Yes'),
      NotificationActionButton(key: 'no', label: 'No'),
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            channelShowBadge: true,
            importance: NotificationImportance.High)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications(
        permissions: [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          NotificationPermission.Badge,
          NotificationPermission.Vibration,
          NotificationPermission.Light,
          NotificationPermission.FullScreenIntent,
        ],
      );
    }
  });

  AwesomeNotifications()
      .actionStream
      .listen((ReceivedNotification receivedNotification) {
    print('ok');
  });
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home aaa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<void> playDeviceDefaultTone() async {
  await FlutterRingtonePlayer.play(
    android: AndroidSounds.alarm,
    ios: IosSounds.glass,
    looping: true, // Android only - API >= 28
    volume: 0.5, // Android only - API >= 28
    asAlarm: false, // Android only - all APIs
  );
}

class _MyHomePageState extends State<MyHomePage> {
  late final LocalNotificationService service;
  int _counter = 0;

  @override
  void initState() {
    service = LocalNotificationService();
    final int helloAlarmID = 0;
    service.initialize();
    AwesomeNotifications().createdStream.listen((notification) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'Notification Created on ${notification.channelKey}',
      )));
    });
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  TextEditingController txtControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.green,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        offset: Offset(0, 0),
                                        blurRadius: 1,
                                        spreadRadius: 1)
                                  ]),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'How Name are you today Afters sa are from sa ?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          decoration:
                              InputDecoration(hintText: 'Search', filled: true),
                          autofocus: true,
                          controller: txtControler,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              final int helloAlarmID = 0;
                              await AndroidAlarmManager.oneShot(
                                  const Duration(seconds: 30),
                                  helloAlarmID,
                                  printHello);
                            },
                            child: Text('Alamar android plus')),
                        ElevatedButton(
                            onPressed: () async {
                              String localTimeZone =
                                  await AwesomeNotifications()
                                      .getLocalTimeZoneIdentifier();

                              AwesomeNotifications().createNotification(
                                content: NotificationContent(
                                  id: 10,
                                  notificationLayout:
                                      NotificationLayout.BigText,
                                  channelKey: 'basic_channel',
                                  title: 'Simple Notification',
                                  body: 'Simple body',
                                  wakeUpScreen: true,
                                  fullScreenIntent: true,
                                  criticalAlert: true,
                                ),
                                schedule: NotificationInterval(
                                  interval: 10,
                                  timeZone: localTimeZone,
                                  preciseAlarm: true,
                                ),
                                actionButtons: <NotificationActionButton>[
                                  NotificationActionButton(
                                      key: 'yes', label: 'Yes'),
                                  NotificationActionButton(
                                      key: 'no', label: 'No'),
                                ],
                              );
                            },
                            child: Text('ok'))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 400,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
