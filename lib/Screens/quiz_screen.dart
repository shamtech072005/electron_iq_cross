// lib/Screens/quiz_screen.dart

import 'package:flutter/material.dart';
import '../Quiz/quiz_data.dart';
import 'quiz_results_screen.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final bool showSolutions;
  final bool useHints;

  const QuizScreen({
    super.key,
    required this.questions,
    required this.showSolutions,
    required this.useHints,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;

  void _handleAnswer(String answer) {
    if (_isAnswered) return; // Prevent changing answer

    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
      if (answer == widget.questions[_currentQuestionIndex].correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
    } else {
      // End of the quiz, navigate to results
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultsScreen(
            score: _score,
            totalQuestions: widget.questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1}/${widget.questions.length}'),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question Text
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                currentQuestion.questionText,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // Options
            ...currentQuestion.options.map((option) {
              return _buildOptionButton(option, currentQuestion.correctAnswer);
            }).toList(),
            
            const Spacer(),

            // Next Question Button (visible after answering)
            if (_isAnswered)
              ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _currentQuestionIndex < widget.questions.length - 1 ? 'Next Question' : 'Finish Quiz',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option, String correctAnswer) {
    bool isSelected = _selectedAnswer == option;
    Color buttonColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    IconData? icon;

    if (_isAnswered) {
      if (option == correctAnswer) {
        // Correct answer is always green
        buttonColor = Colors.green.shade100;
        borderColor = Colors.green;
        icon = Icons.check_circle_rounded;
      } else if (isSelected && option != correctAnswer) {
        // User's wrong selection is red
        buttonColor = Colors.red.shade100;
        borderColor = Colors.red;
        icon = Icons.cancel_rounded;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () => _handleAnswer(option),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: buttonColor,
          side: BorderSide(color: borderColor, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: borderColor),
              const SizedBox(width: 10),
            ],
            Text(option, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}