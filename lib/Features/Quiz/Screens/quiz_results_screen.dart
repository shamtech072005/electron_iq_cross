// lib/Features/Quiz/Screens/quiz_results_screen.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../Shared Widgets/Widgets/science_background_painter.dart';
import '../../../Shared Widgets/Widgets/bouncing_button.dart';

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
    final double percentage = totalQuestions > 0 ? (score / totalQuestions) * 100 : 0;
    
    String title;
    String animationPath;
    Color scoreColor;

    if (percentage >= 80) {
      title = 'Excellent!';
      animationPath = 'assets/animations/trophy.json';
      scoreColor = Colors.tealAccent;
    } else if (percentage >= 50) {
      title = 'Good Effort!';
      animationPath = 'assets/animations/thinking.json';
      scoreColor = Colors.amberAccent;
    } else {
      title = 'Keep Practicing!';
      animationPath = 'assets/animations/sad.json';
      scoreColor = Colors.redAccent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: const Color(0xFF112240),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          const ScienceBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  animationPath,
                  height: 150,
                  repeat: true,
                ),
                const SizedBox(height: 20),
                Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 20),
                const Text('You Scored', style: TextStyle(fontSize: 20, color: Colors.white70)),
                const SizedBox(height: 10),
                Text(
                  '$score / $totalQuestions',
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: scoreColor),
                ),
                Text('(${percentage.toStringAsFixed(1)}%)', style: const TextStyle(fontSize: 24, color: Colors.white70)),
                const SizedBox(height: 50),
                BouncingButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Back to Main Menu', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}