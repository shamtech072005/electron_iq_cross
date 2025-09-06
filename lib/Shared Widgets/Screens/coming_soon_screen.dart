// lib/Shared Widgets/Screens/coming_soon_screen.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Widgets/science_background_painter.dart';

class ComingSoonScreen extends StatelessWidget {
  final String featureName;

  const ComingSoonScreen({
    super.key,
    required this.featureName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(featureName),
        backgroundColor: const Color(0xFF112240),
      ),
      body: Stack(
        children: [
          const ScienceBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lottie animation for visual appeal
                  Lottie.asset(
                    'assets/animations/rocket.json', // Make sure you've added this file
                    height: 250,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Coming Soon!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Our team is hard at work building the amazing "$featureName" feature. Stay tuned for exciting updates!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
