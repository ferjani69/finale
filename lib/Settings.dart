/*import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Section',
            tiles: [
              SettingsTile.switchTile(
                title: 'Dark Mode',
                leading: Icon(Icons.dark_mode),
                switchValue: false, // This should be a state variable
                onToggle: (bool value) {
                  // Handle the toggle
                },
              ),
              SettingsTile(
                title: 'Language',
                leading: Icon(Icons.language),
                onPressed: () {
                  // Navigate to language selection
                },
              ),
              SettingsTile.switchTile(
                title: 'Notifications',
                leading: Icon(Icons.notifications),
                switchValue: true, // This should be a state variable
                onToggle: (bool value) {
                  // Handle the toggle
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/