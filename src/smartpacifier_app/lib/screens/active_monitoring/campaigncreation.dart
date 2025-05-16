// File: lib/screens/active_monitoring/campaigncreation.dart

import 'package:flutter/material.dart';

class CampaignCreation extends StatelessWidget {
  final String backend;
  const CampaignCreation({Key? key, required this.backend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Campaign — $backend')),
      body: Center(child: Text('Campaign creation UI for $backend')),
    );
  }
}
