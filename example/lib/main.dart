import 'package:flutter/material.dart';
import 'package:mintegral_plugin/mintegral_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Mintegral Plugin Example')),
        body: MintegralScreen(),
      ),
    );
  }
}

class MintegralScreen extends StatefulWidget {
  const MintegralScreen({super.key});

  @override
  State<MintegralScreen> createState() => _MintegralScreenState();
}

class _MintegralScreenState extends State<MintegralScreen> {
  String _statusMessage = 'Press a button to begin';

  void _initialize() {
    setState(() {
      _statusMessage = 'Initializing Mintegral SDK...';
    });

    MintegralPlugin.initialize(
      appId: '<APP_ID>',
      appKey: '<APP_KEY>',
      onInitSuccess: () {
        setState(() {
          _statusMessage = 'Mintegral SDK Initialized Successfully ✅';
        });
      },
      onInitFail: (error) {
        setState(() {
          _statusMessage = 'Initialization Failed ❌: $error';
        });
      },
    );
  }

  void _loadAndShowAd() {
    setState(() {
      _statusMessage = 'Loading Ad...';
    });

    MintegralPlugin.loadAd(
      placementId: '<PLACEMENT_ID>',
      unitId: '<UNIT_ID>',
      adLoadCallback: (ad, {error}) async {
        if (ad != null) {
          setState(() {
            _statusMessage = 'Ad Loaded ✅ Showing Ad...';
          });
          await Future.delayed(Durations.long2, () async => await ad.show());
          setState(() {
            _statusMessage = 'Ad Displayed Successfully ✅';
          });
        } else {
          setState(() {
            _statusMessage = 'Ad Load Failed ❌: $error';
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 30,
        children: [
          ElevatedButton(onPressed: _initialize, child: Text('Initialize Sdk')),
          ElevatedButton(
            onPressed: _loadAndShowAd,
            child: Text('Load & Show Ad'),
          ),
          Text(_statusMessage, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
