import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  final RxBool isDarkMode;
  const SettingsScreen({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60.0,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFF144CA1),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: const Text(
              "Settings",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDarkMode.value,
            onChanged: (value) => isDarkMode.value = value,
          ),
        ],
      ),
    );
  }
}
