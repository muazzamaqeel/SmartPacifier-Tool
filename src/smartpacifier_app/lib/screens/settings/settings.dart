import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const Settings({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<bool>(
              title: const Text('Light Theme'),
              value: false,
              groupValue: isDark,
              onChanged: (v) {
                if (v != null) {
                  onThemeChanged(v);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<bool>(
              title: const Text('Dark Theme'),
              value: true,
              groupValue: isDark,
              onChanged: (v) {
                if (v != null) {
                  onThemeChanged(v);
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left column: Account & Theme stacked
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Account settings
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Account'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showThemeDialog(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Theme'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Right column: Notifications spans both rows
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Notification settings
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Notifications'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
