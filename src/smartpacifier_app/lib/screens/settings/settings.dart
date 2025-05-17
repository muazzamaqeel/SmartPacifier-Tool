import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final String backend;
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const Settings({
    Key? key,
    required this.backend,
    required this.isDark,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool _notificationsEnabled;
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = true;
    _isDark = widget.isDark;
  }

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
              groupValue: _isDark,
              onChanged: (v) {
                if (v != null) {
                  setState(() => _isDark = v);
                  widget.onThemeChanged(v);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<bool>(
              title: const Text('Dark'),
              value: true,
              groupValue: _isDark,
              onChanged: (v) {
                if (v != null) {
                  setState(() => _isDark = v);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings — ${widget.backend}'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Broker Check'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // TODO
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text('Theme'),
            subtitle: Text(_isDark ? 'Dark' : 'Light'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showThemeDialog,
          ),
          const Divider(),

          SwitchListTile.adaptive(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
          const Divider(),

          // …any other settings tiles you like…
        ],
      ),
    );
  }
}
