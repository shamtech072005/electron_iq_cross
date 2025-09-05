// lib/Screens/premium_screen.dart

import 'package:flutter/material.dart';
import '../Widgets/science_background_painter.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unlock Premium'),
        backgroundColor: const Color(0xFF112240),
      ),
      body: Stack(
        children: [
          const ScienceBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Choose Your Plan',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Unlock powerful features to supercharge your learning.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Row to hold the two plan cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Plan Card
                      _buildPlanCard(
                        context: context,
                        title: 'Basic',
                        price: 'Free',
                        isPremium: false,
                        features: const {
                          'Explore All 118 Elements': true,
                          'Standard Quiz Mode': true,
                          'Quiz Progress Tracking': false,
                          'Personalized Review Quizzes': false,
                          '3D Interactive Atom Models': false,
                        },
                      ),
                      const SizedBox(width: 24),
                      // Premium Plan Card
                      _buildPlanCard(
                        context: context,
                        title: 'Premium',
                        price: '\$9.99/year',
                        isPremium: true,
                        features: const {
                          'Explore All 118 Elements': true,
                          'Standard Quiz Mode': true,
                          'Quiz Progress Tracking': true,
                          'Personalized Review Quizzes': true,
                          '3D Interactive Atom Models': true,
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // A reusable widget to build the plan cards
  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    required bool isPremium,
    required Map<String, bool> features,
  }) {
    return Expanded(
      child: Card(
        elevation: isPremium ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isPremium ? Colors.tealAccent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isPremium ? Colors.tealAccent : Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const Divider(height: 32, color: Colors.white24),
              ...features.entries.map((entry) {
                return _buildFeatureRow(
                  text: entry.key,
                  isIncluded: entry.value,
                );
              }).toList(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isPremium ? () {} : null, // Only premium is pressable
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPremium ? Colors.tealAccent : Colors.grey[700],
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey.shade800,
                ),
                child: Text(isPremium ? 'Subscribe' : 'Current Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A reusable widget for each feature row with a tick or cross
  Widget _buildFeatureRow({required String text, required bool isIncluded}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            isIncluded ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isIncluded ? Colors.greenAccent[400] : Colors.redAccent,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isIncluded ? Colors.white : Colors.white54,
                decoration: isIncluded ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

