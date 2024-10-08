import 'dart:isolate';
import 'dart:ui';

import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _sendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService().listRestaurant();
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _sendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _sendPort?.send(null);
  }
}
