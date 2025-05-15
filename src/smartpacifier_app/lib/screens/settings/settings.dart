// File: lib/screens/settings/settings.dart

import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const Settings({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

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
              groupValue: widget.isDark,
              onChanged: (v) {
                if (v != null) {
                  widget.onThemeChanged(v);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<bool>(
              title: const Text('Dark'),
              value: true,
              groupValue: widget.isDark,
              onChanged: (v) {
                if (v != null) {
                  widget.onThemeChanged(v);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        const Divider(),

        // Account
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Broker Check'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to Account screen
          },
        ),
        const Divider(),

        // Theme
        ListTile(
          leading: const Icon(Icons.color_lens_outlined),
          title: const Text('Theme'),
          subtitle: Text(widget.isDark ? 'Dark' : 'Light'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _showThemeDialog,
        ),
        const Divider(),

        // Notifications
        SwitchListTile.adaptive(
          secondary: const Icon(Icons.notifications_outlined),
          title: const Text('Enable Notifications'),
          value: _notificationsEnabled,
          onChanged: (v) => setState(() => _notificationsEnabled = v),
        ),
        const Divider(),

        // You can add more settings here:
        // e.g. Privacy, About, etc.
      ],
    );
  }
}
