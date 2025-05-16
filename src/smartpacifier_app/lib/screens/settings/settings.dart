import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  /// The backend whose settings we’re editing
  final String backend;

  const Settings({
    Key? key,
    required this.backend,
  }) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notificationsEnabled = true;

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<bool>(
              title: const Text('Light'),
              value: false,
              groupValue: false, // remove theme logic or wire in your own
              onChanged: (_) => Navigator.of(context).pop(),
            ),
            RadioListTile<bool>(
              title: const Text('Dark'),
              value: true,
              groupValue: false,
              onChanged: (_) => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings — ${widget.backend}'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Broker Check (Account)
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Broker Check'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // TODO: navigate if needed
          ),
          const Divider(),

          // Theme selector
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text('Theme'),
            subtitle: const Text('Light / Dark'), // or reflect actual
            trailing: const Icon(Icons.chevron_right),
            onTap: _showThemeDialog,
          ),
          const Divider(),

          // Notifications toggle
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
          const Divider(),

          // Add any additional settings here…
        ],
      ),
    );
  }
}
