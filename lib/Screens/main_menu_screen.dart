// lib/Screens/main_menu_screen.dart

import 'package:flutter/material.dart';
import '../Widgets/science_background_painter.dart';
import 'periodic_table_view.dart';
import 'quiz_menu_screen.dart';
import 'comparison_selection_screen.dart';
import 'profile_screen.dart'; // <-- 1. Import the new profile screen

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. Add a transparent AppBar to host the drawer button
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // 3. Add the Drawer to the Scaffold
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          const ScienceBackground(),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Electron IQ',
                    style: TextStyle(
                      fontSize: 62,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Your Interactive Chemistry Guide',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 60),
                  _buildMenuCard(
                    context: context,
                    icon: Icons.table_chart_rounded,
                    title: 'Periodic Table',
                    subtitle: 'Explore all 118 elements',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PeriodicTableView()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context: context,
                    icon: Icons.quiz_rounded,
                    title: 'Quiz Mode',
                    subtitle: 'Test your chemistry knowledge',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QuizMenuScreen()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context: context,
                    icon: Icons.compare_arrows_rounded,
                    title: 'Element Comparison Tool',
                    subtitle: 'Compare properties side-by-side',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ComparisonSelectionScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.tealAccent),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. A reusable Drawer widget for navigation
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0A192F), // Match the dark theme background
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF112240), // Match the card color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.tealAccent,
                  child: Text(
                    'U', // Placeholder for User Initial
                    style: TextStyle(fontSize: 32, color: Color(0xFF0A192F), fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded, color: Colors.white70),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Close the drawer first
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          // You can add other drawer items like Settings, About, etc. here
        ],
      ),
    );
  }
}

// The PlaceholderScreen for the comparison tool can be kept or removed if not needed elsewhere.
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          const ScienceBackground(),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.construction_rounded, size: 60, color: Colors.white38),
                SizedBox(height: 20),
                Text(
                  'Coming Soon!',
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
