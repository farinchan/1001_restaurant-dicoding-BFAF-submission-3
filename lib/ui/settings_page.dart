import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/style.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        elevation: 0,
        backgroundColor: settingColor,
      ),
      body: Consumer<PreferencesProvider>(
        builder: (context, provider, _) {
          return ListView(
            children: [
              Material(
                child: ListTile(
                  title: Text('Scheduling News'),
                  trailing: Consumer<SchedulingProvider>(
                    builder: (context, scheduled, _) {
                      return Switch.adaptive(
                          value: provider.isDailyRestoActive,
                          onChanged: (value) async {
                            if (TargetPlatform.iOS == true) {
                              AlertDialog(
                                title: Text('Coming Soon!'),
                                content:
                                    Text('This feature will be coming soon!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            } else {
                              scheduled.scheduledResto(value);
                              provider.enableDailyResto(value);
                            }
                          });
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
