import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:electron_iq/Auth/auth_gate.dart';
import 'package:electron_iq/Core/Services/NetworkService.dart';
import 'package:electron_iq/Core/Services/version_control_service.dart';
import 'package:electron_iq/Core/utils/constant.dart';
import 'package:electron_iq/Shared%20Widgets/Screens/Status/no_network_screen.dart';
import 'package:electron_iq/Shared%20Widgets/Screens/Status/update_app_screen.dart';
import 'package:electron_iq/Shared%20Widgets/Widgets/science_background_painter.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingMessage = 'Initializing...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Check network connectivity
    setState(() {
      _loadingMessage = 'Checking network connection...';
      _progress = 0.25;
    });
    await Future.delayed(const Duration(milliseconds: 500)); // Visual delay

    final networkService = NetworkService();
    print(await networkService.isNetworkConnected() == false);
    if (await networkService.isNetworkConnected() == false) {
      print("connected");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NoNetworkScreen()),
      );
      return;
    }

    // 2. Check for app updates
    setState(() {
      _loadingMessage = 'Verifying app version...';
      _progress = 0.5;
    });
    await Future.delayed(const Duration(milliseconds: 500)); // Visual delay
    
    final versionService = VersionControlService(
      minimumRequiredVersion: Constant.minRequiredVersion,
      apiEndpoint: Constant.versionApiEndpoint,
    );

    await versionService.initialize();
print(versionService.getCurrentVersion());
print("new version ${versionService.getNewVersion()}");
print("update available  ${versionService.isUpdateAvailable()}");
    if (versionService.isUpdateAvailable()) {
      print("new version ${versionService.getNewVersion()}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              UpdateAppScreen(newVersion:versionService.getNewVersion() ?? ''),
        ),
      );
      return;
    }

    // 3. Navigate to the app
    setState(() {
      _loadingMessage = 'Loading...';
      _progress = 1.0;
    });

    await Future.delayed(const Duration(seconds: 1)); // Simulate loading

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthGate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ScienceBackground(), // The animated background
          Center(
            child: CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 13.0,
              animation: true,
              percent: _progress,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/appIcon.png', // Your app icon
                      height: 120,
                      width: 120,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white),
                  ),
                ],
              ),
              footer: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _loadingMessage,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: Colors.white70),
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.tealAccent,
              backgroundColor: Colors.white12,
            ),
          ),
        ],
      ),
    );
  }
}

