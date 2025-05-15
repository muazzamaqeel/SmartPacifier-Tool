// File: lib/components/sidebar/sidebar.dart

import 'package:flutter/material.dart';
import '../../screens/active_monitoring/activemonitoring.dart';
import '../../screens/active_monitoring/campaigncreation.dart';
import '../../screens/settings/settings.dart';

enum SidebarItem { activeMonitoring, campaignCreation, settings }

class Sidebar extends StatelessWidget {
  final List<String> clients;
  final String? selectedClient;
  final ValueChanged<String> onClientSelected;
  final SidebarItem selectedItem;
  final ValueChanged<SidebarItem> onItemSelected;
  final bool isExtended;
  final VoidCallback onToggle;

  const Sidebar({
    super.key,
    required this.clients,
    required this.selectedClient,
    required this.onClientSelected,
    required this.selectedItem,
    required this.onItemSelected,
    required this.isExtended,
    required this.onToggle,
  });

  Widget _tile({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          color: selected ? Colors.grey.withOpacity(0.2) : null,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              Icon(icon),
              if (isExtended) ...[
                const SizedBox(width: 12),
                Expanded(child: Text(label)),
              ],
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isExtended ? 200 : 60,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        children: [
          IconButton(
            icon: Icon(isExtended ? Icons.chevron_left : Icons.menu),
            onPressed: onToggle,
          ),
          if (isExtended)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Connected Clients',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (var c in clients)
                  _tile(
                    icon: Icons.cloud_outlined,
                    label: c,
                    selected: c == selectedClient,
                    onTap: () => onClientSelected(c),
                  ),
                if (clients.isNotEmpty) const Divider(),
                _tile(
                  icon: Icons.show_chart_outlined,
                  label: 'Active Monitoring',
                  selected: selectedItem == SidebarItem.activeMonitoring,
                  onTap: () => onItemSelected(SidebarItem.activeMonitoring),
                ),
                _tile(
                  icon: Icons.campaign_outlined,
                  label: 'Create Campaign',
                  selected: selectedItem == SidebarItem.campaignCreation,
                  onTap: () => onItemSelected(SidebarItem.campaignCreation),
                ),
                _tile(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  selected: selectedItem == SidebarItem.settings,
                  onTap: () => onItemSelected(SidebarItem.settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
