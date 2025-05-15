// File: lib/components/sidebar/sidebar.dart

import 'package:flutter/material.dart';
import '../../screens/active_monitoring/activemonitoring.dart';
import '../../screens/active_monitoring/campaigncreation.dart';
import '../../screens/settings/settings.dart';

enum SidebarItem { activeMonitoring, campaignCreation, settings }

class Sidebar extends StatelessWidget {
  final SidebarItem selectedItem;
  final ValueChanged<SidebarItem> onItemSelected;
  final VoidCallback onClose;

  const Sidebar({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: true,
      // top chevron to collapse the rail entirely
      leading: IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: onClose,
      ),
      selectedIndex: SidebarItem.values.indexOf(selectedItem),
      onDestinationSelected: (idx) =>
          onItemSelected(SidebarItem.values[idx]),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.show_chart_outlined),
          selectedIcon: Icon(Icons.show_chart),
          label: Text('Active Monitoring'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.campaign_outlined),
          selectedIcon: Icon(Icons.campaign),
          label: Text('Create Campaign'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
