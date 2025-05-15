import 'package:flutter/material.dart';

class CampaignCreation extends StatelessWidget {
  const CampaignCreation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Campaign')),
      body: const Center(child: Text('Campaign creation UI goes here')),
    );
  }
}
