// File: lib/screens/app_shell.dart

import 'package:flutter/material.dart';
import 'sidebar.dart';
import '../../screens/active_monitoring/activemonitoring.dart';
import '../../screens/active_monitoring/campaigncreation.dart';
import '../../screens/settings/settings.dart';

class AppShell extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const AppShell({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  SidebarItem _selected = SidebarItem.activeMonitoring;
  bool _railVisible = false;  // start closed if you like

  Widget _buildPage() {
    switch (_selected) {
      case SidebarItem.activeMonitoring:
        return const ActiveMonitoring();
      case SidebarItem.campaignCreation:
        return const CampaignCreation();
      case SidebarItem.settings:
        return Settings(
          isDark: widget.isDark,
          onThemeChanged: widget.onThemeChanged,
        );
    }
  }

  String _titleFor(SidebarItem item) {
    switch (item) {
      case SidebarItem.activeMonitoring:
        return 'Active Monitoring';
      case SidebarItem.campaignCreation:
        return 'Create Campaign';
      case SidebarItem.settings:
        return 'Settings';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // ← only build the rail when it's visible
            if (_railVisible) ...[
              Sidebar(
                selectedItem: _selected,
                onItemSelected: (it) => setState(() => _selected = it),
                onClose: () => setState(() => _railVisible = false),
              ),
              const VerticalDivider(width: 1, thickness: 1),
            ],

            // main content
            Expanded(
              child: Column(
                children: [
                  // header bar with toggle when rail is hidden
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Row(
                      children: [
                        if (!_railVisible)
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () =>
                                setState(() => _railVisible = true),
                          ),
                        Text(
                          _titleFor(_selected),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // the selected page
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildPage(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
