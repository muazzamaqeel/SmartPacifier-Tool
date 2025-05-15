import 'package:flutter/material.dart';
import '../components/sidebar/sidebar.dart';              // ← correct relative path
import 'active_monitoring/activemonitoring.dart';
import 'active_monitoring/campaigncreation.dart';
import 'settings/settings.dart';

class AppShell extends StatefulWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  SidebarItem _selected = SidebarItem.activeMonitoring;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selected) {
      case SidebarItem.activeMonitoring:
        page = const ActiveMonitoring();
        break;
      case SidebarItem.campaignCreation:
        page = const CampaignCreation();
        break;
      case SidebarItem.settings:
        page = const Settings();
        break;
    }

    return Scaffold(
      body: Row(
        children: [
          // Always‐visible rail
          Sidebar(
            selectedItem: _selected,
            onItemSelected: (item) => setState(() => _selected = item),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: page),
        ],
      ),
    );
  }
}
