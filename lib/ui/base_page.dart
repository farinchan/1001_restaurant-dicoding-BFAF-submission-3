import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/common/style.dart';
import 'package:restaurant_app/ui/favorite_page.dart';
import 'package:restaurant_app/ui/home_page.dart';
import 'package:restaurant_app/ui/search_page.dart';
import 'package:restaurant_app/ui/settings_page.dart';
import 'package:restaurant_app/utils/notifications_helper.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int indexBottomNav = 0;
  List<Widget> widgetOptions = [
    HomePage(),
    SearchPage(),
    BookmarkPage(),
    SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject("/detail_screen");
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(indexBottomNav),
      bottomNavigationBar: SalomonBottomBar(
          onTap: (index) {
            setState(() {
              indexBottomNav = index;
            });
          },
          currentIndex: indexBottomNav,
          items: [
            SalomonBottomBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                selectedColor: HomeColor),
            SalomonBottomBarItem(
                icon: Icon(Icons.search),
                title: Text("Search"),
                selectedColor: SearchColor),
            SalomonBottomBarItem(
                icon: Icon(Icons.favorite),
                title: Text("Favorite"),
                selectedColor: FavoriteColor),
            SalomonBottomBarItem(
                icon: Icon(Icons.settings),
                title: Text("Setting"),
                selectedColor: settingColor),
          ]),
    );
  }
}
