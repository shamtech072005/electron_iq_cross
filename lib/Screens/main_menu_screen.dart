// lib/Screens/main_menu_screen.dart

import 'package:flutter/material.dart';
import '../Widgets/science_background_painter.dart';
import 'periodic_table_view.dart';
import 'quiz_menu_screen.dart';
import 'comparison_selection_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // --- FIX: Using a brighter accent color for high contrast ---
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
              // --- FIX: Using a more visible color for the arrow ---
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}

// You can keep the PlaceholderScreen class here if you need it for other features.
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