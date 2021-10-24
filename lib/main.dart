import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant_element.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/ui/detail_screen.dart';
import 'package:restaurant_app/ui/base_page.dart';
import 'package:restaurant_app/ui/splashscreen_view.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:restaurant_app/utils/notifications_helper.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/preferences/preference_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  await AndroidAlarmManager.initialize();
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<RestaurantProvider>(
            create: (_) => RestaurantProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider<SearchRestaurantProvider>(
            create: (_) => SearchRestaurantProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider<PreferencesProvider>(
            create: (_) => PreferencesProvider(
                preferencesHelper: PreferencesHelper(
                    sharedPreferences: SharedPreferences.getInstance())),
          ),
          ChangeNotifierProvider<SchedulingProvider>(
            create: (_) => SchedulingProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: "restaurant app ",
          theme: ThemeData(
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
          initialRoute: "/splashscreen",
          routes: {
            "/splashscreen": (context) => SplashscreenView(),
            "/base_page": (context) => BasePage(),
            "/detail_screen": (context) => DetailScreen(
                  resto: ModalRoute.of(context)!.settings.arguments!
                      as RestaurantElement,
                ),
          },
        ));
  }
}
