import 'package:flutter/material.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';

class ActivityNotificationSetting {
  String name;
  bool isEnabled;
  ActivityNotificationSetting({
    required this.name,
    this.isEnabled = false,
  });
}

class ActivityNotificationSettingsPage extends StatefulWidget {
  const ActivityNotificationSettingsPage({super.key});

  @override
  State<ActivityNotificationSettingsPage> createState() => _ActivityNotificationSettingsPageState();
}

class _ActivityNotificationSettingsPageState extends State<ActivityNotificationSettingsPage> {
  List<ActivityNotificationSetting> settingsList = [
    ActivityNotificationSetting(
      name: "Daily Reminder",
    ),
    ActivityNotificationSetting(
      name: "Reminder & Alerts",
    ),
    ActivityNotificationSetting(
      name: "Acitivity Updates",
    ),
    ActivityNotificationSetting(
      name: "Reports",
    ),
    ActivityNotificationSetting(
      name: "News & Updates",
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Notification Settings"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        separatorBuilder: (context, _) => const SizedBox(height: 24.0),
        itemCount: settingsList.length,
        itemBuilder: (context, index) {
          ActivityNotificationSetting setting = settingsList[index];
          return SwitchListTile.adaptive(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            tileColor: whiteColor,
            activeColor: himalayanBlue,
            value: setting.isEnabled, 
            title: Text(
              setting.name,
              style: const TextStyle(
                fontSize: h9,
                fontWeight: FontWeight.w500,
              ),
            ),
            onChanged: (bool value) {
              setState(() {
                setting.isEnabled = value;
              });
            }
          );
        }
      ),
    );
  }
}