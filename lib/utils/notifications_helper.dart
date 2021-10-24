import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurant restaurant) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "restaurant";

    var platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
            _channelId, _channelName, _channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            styleInformation: DefaultStyleInformation(true, true)));

    var titleNotification = "<b>Headline Restaurant</b>";
    var randomResto = Random().nextInt(restaurant.count);
    var titleNews = restaurant.restaurants[randomResto].name;
    var payload = {"id": restaurant.restaurants[randomResto].id};

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleNews, platformChannelSpecifics,
        payload: json.encode(payload));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = json.decode(payload);
        Navigation.intentWithData(route, data["id"]);
      },
    );
  }
}
