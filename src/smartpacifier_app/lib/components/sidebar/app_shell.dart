// File: lib/screens/app_shell.dart

import 'package:flutter/material.dart';
import 'package:smartpacifier_app/components/sidebar/sidebar.dart';
import '../../screens/active_monitoring/activemonitoring.dart';
import '../../screens/active_monitoring/campaigncreation.dart';
import 'package:smartpacifier_app/screens/settings/settings.dart';
import '../../client_layer/connector.dart';

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
  final Connector _connector = Connector();
  late final Stream<List<String>> _stream;
  List<String> _clients = [];
  String? _selectedClient;
  SidebarItem _selectedItem = SidebarItem.activeMonitoring;
  bool _railVisible = true;

  @override
  void initState() {
    super.initState();
    _stream = _connector.clientsStream;
    _stream.listen((list) {
      setState(() {
        _clients = list;
        _selectedClient ??= list.isNotEmpty ? list.first : null;
      });
    });
  }

  Widget _page() {
    final id = _selectedClient!;
    switch (_selectedItem) {
      case SidebarItem.activeMonitoring:
        return ActiveMonitoring(clientId: id);
      case SidebarItem.campaignCreation:
        return CampaignCreation(clientId: id);
      case SidebarItem.settings:
        return Settings(
          clientId: id,
          isDark: widget.isDark,
          onThemeChanged: widget.onThemeChanged,
        );
    }
  }

  String _title() {
    switch (_selectedItem) {
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
            if (_railVisible && _clients.isNotEmpty) ...[
              Sidebar(
                clients: _clients,
                selectedClient: _selectedClient,
                onClientSelected: (c) => setState(() => _selectedClient = c),
                selectedItem: _selectedItem,
                onItemSelected: (it) => setState(() => _selectedItem = it),
                isExtended: true,
                onToggle: () => setState(() => _railVisible = false),
              ),
              const VerticalDivider(width: 1),
            ],
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        if (!_railVisible)
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () =>
                                setState(() => _railVisible = true),
                          ),
                        Text(
                          _selectedClient == null
                              ? 'Waiting for backends…'
                              : '${_title()} — $_selectedClient',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _selectedClient == null
                          ? const Center(child: Text('Waiting for backends…'))
                          : _page(),
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
