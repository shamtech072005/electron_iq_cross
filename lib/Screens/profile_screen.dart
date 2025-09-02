// lib/Screens/profile_screen.dart

import 'package:flutter/material.dart';
import '../Widgets/science_background_painter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: const Stack(
        children: [
          ScienceBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_pin_rounded, size: 80, color: Colors.white38),
                SizedBox(height: 20),
                Text(
                  'Profile Page',
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
                Text(
                  'User settings and information will be here.',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
