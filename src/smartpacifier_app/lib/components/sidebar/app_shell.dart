import 'package:flutter/material.dart';
import 'package:smartpacifier_app/client_layer/connector.dart';
import 'package:smartpacifier_app/components/sidebar/sidebar.dart';
import 'package:smartpacifier_app/screens/active_monitoring/activemonitoring.dart';
import 'package:smartpacifier_app/screens/active_monitoring/campaigncreation.dart';
import 'package:smartpacifier_app/screens/settings/settings.dart';

class AppShell extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const AppShell({
    Key? key,
    required this.isDark,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final Connector _connector = Connector();
  List<String> _clients = [];
  String? _selectedClient;
  SidebarItem _selectedItem = SidebarItem.activeMonitoring;
  bool _railExtended = true;

  @override
  void initState() {
    super.initState();
    _connector.clientsStream.listen((list) {
      setState(() {
        _clients = list;
        _selectedClient ??= list.isNotEmpty ? list.first : null;
      });
    });
  }

  Widget _buildContent() {
    if (_selectedClient == null) {
      return const Center(child: Text('No backend selected'));
    }
    switch (_selectedItem) {
      case SidebarItem.activeMonitoring:
        return ActiveMonitoring(backend: _selectedClient!);
      case SidebarItem.campaignCreation:
        return CampaignCreation(backend: _selectedClient!);
      case SidebarItem.settings:
        return Settings(
          backend: _selectedClient!,
          isDark: widget.isDark,
          onThemeChanged: widget.onThemeChanged,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            clients: _clients,
            selectedClient: _selectedClient,
            onClientSelected: (c) => setState(() {
              _selectedClient = c;
              _selectedItem = SidebarItem.activeMonitoring;
            }),
            selectedItem: _selectedItem,
            onItemSelected: (s) => setState(() => _selectedItem = s),
            isExtended: _railExtended,
            onToggle: () => setState(() => _railExtended = !_railExtended),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}
