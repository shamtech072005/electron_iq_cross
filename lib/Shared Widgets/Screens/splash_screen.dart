import 'dart:async';
import 'package:electron_iq/Features/Periodic%20Table/Screens/periodic_table_view.dart';
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
  final String _loadingMessage = 'Initializing...';

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

    // Minimum splash time
    await Future.delayed(const Duration(seconds: 3));

    // Navigate after all tasks are done and animation is near completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PeriodicTableView()),
          );
        }
      }
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