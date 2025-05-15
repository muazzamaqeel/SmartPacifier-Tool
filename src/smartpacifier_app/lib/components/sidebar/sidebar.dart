// components/sidebar/sidebar.dart

import 'package:flutter/material.dart';
import '../../screens/active_monitoring/activemonitoring.dart';
import '../../screens/active_monitoring/campaigncreation.dart';
import '../../screens/settings/settings.dart';

enum SidebarItem { activeMonitoring, campaignCreation, settings }

class Sidebar extends StatelessWidget {
  final SidebarItem selectedItem;
  final ValueChanged<SidebarItem> onItemSelected;

  const Sidebar({
    Key? key,
    required this.selectedItem,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: SidebarItem.values.indexOf(selectedItem),
      onDestinationSelected: (index) =>
          onItemSelected(SidebarItem.values[index]),
      labelType: NavigationRailLabelType.selected,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.show_chart),
          label: Text('Active Monitoring'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.create),
          label: Text('Create Campaign'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
