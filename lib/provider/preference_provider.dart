import 'package:flutter/material.dart';
import 'package:restaurant_app/data/preferences/preference_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyRestoPreferences();
  }

  bool _isDailyRestosActive = false;
  bool get isDailyRestoActive => _isDailyRestosActive;

  void _getDailyRestoPreferences() async {
    _isDailyRestosActive = await preferencesHelper.isDailyRestoActive;
    notifyListeners();
  }

  void enableDailyResto(bool value) {
    preferencesHelper.setDailyResto(value);
    _getDailyRestoPreferences();
  }
}
