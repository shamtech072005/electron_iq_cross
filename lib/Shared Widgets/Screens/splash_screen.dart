import 'dart:async';
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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _loadingMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Total animation duration
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {}); // Redraw the widget on each animation frame
      });

    _initializeApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Start the smooth animation
    _controller.forward();

    // Perform all initialization tasks concurrently
    await Future.wait([
      _checkNetwork(),
      _checkVersion(),
      Future.delayed(const Duration(seconds: 1)), // Minimum splash time
    ]);

    // Navigate after all tasks are done and animation is near completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AuthGate()),
          );
        }
      }
    });
  }

  Future<void> _checkNetwork() async {
    setState(() {
      _loadingMessage = 'Checking network connection...';
    });
    final networkService = NetworkService();
    if (!await networkService.isNetworkConnected()) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NoNetworkScreen()),
        );
      }
    }
  }

  Future<void> _checkVersion() async {
    setState(() {
      _loadingMessage = 'Verifying app version...';
    });
    final versionService = VersionControlService(
      minimumRequiredVersion: Constant.minRequiredVersion,
      apiEndpoint: Constant.versionApiEndpoint,
    );
    await versionService.initialize();

    if (versionService.isUpdateAvailable()) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                UpdateAppScreen(newVersion: versionService.getNewVersion() ?? ''),
          ),
        );
      }
    }
    setState(() {
      _loadingMessage = 'Loading...';
    });
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
              percent: _animation.value, // Driven by the animation controller
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
                    '${(_animation.value * 100).toInt()}%',
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