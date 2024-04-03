import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/ui/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  static const routeName = "/setting_page";
  static const String valuePref = "value";

  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
    _loadValue();
  }

  @override
  Widget build(BuildContext context) {
    final schedulingProvider = Provider.of<SchedulingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Text(
                "Enable notification",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Switch.adaptive(
              value: schedulingProvider.isScheduled,
              onChanged: (value) async {
                if (Platform.isIOS) {
                  customDialog(context);
                } else {
                  schedulingProvider.scheduledRestaurant(value);
                  _saveValue(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(SettingPage.valuePref, value);
  }

  void _loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(SettingPage.valuePref) ?? false;
    Provider.of<SchedulingProvider>(context, listen: false)
        .scheduledRestaurant(value);
  }
}
