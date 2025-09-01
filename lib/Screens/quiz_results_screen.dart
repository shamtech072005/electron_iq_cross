// lib/Screens/quiz_results_screen.dart

import 'package:flutter/material.dart';

class QuizResultsScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const QuizResultsScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = (score / totalQuestions) * 100;
    final bool passed = percentage >= 50;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              passed ? 'Congratulations!' : 'Better Luck Next Time!',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'You Scored',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(
              '$score / $totalQuestions',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: passed ? Colors.green.shade600 : Colors.red.shade600,
              ),
            ),
            Text(
              '(${percentage.toStringAsFixed(1)}%)',
              style: const TextStyle(fontSize: 24, color: Colors.black54),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Pop until we get to the first screen (main menu)
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Back to Main Menu', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}