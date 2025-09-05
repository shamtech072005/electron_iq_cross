// lib/Screens/main_menu_screen.dart

import 'package:electron_iq/Widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import '../Widgets/science_background_painter.dart';
import 'periodic_table_view.dart';
import 'quiz_menu_screen.dart';
import 'comparison_selection_screen.dart';
// The profile screen import is no longer needed
// import 'profile_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
