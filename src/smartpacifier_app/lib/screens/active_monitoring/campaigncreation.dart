// File: lib/screens/active_monitoring/campaigncreation.dart

import 'package:flutter/material.dart';

class CampaignCreation extends StatelessWidget {
  final String clientId;
  const CampaignCreation({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Campaign — $clientId')),
      body: const Center(child: Text('Campaign creation UI goes here')),
    );
  }
}
