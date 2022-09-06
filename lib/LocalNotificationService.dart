import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_launcher');

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _localNotificationService.initialize(settings,
        onSelectNotification: onSelectNotification);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'Descri',
            importance: Importance.max,
            playSound: true);

    return const NotificationDetails(android: androidNotificationDetails);
  }

  Future<void> showNotification(
      {required int id, required String title, required String body}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  void onSelectNotification(String? payload) {
    print('object');
  }
}
