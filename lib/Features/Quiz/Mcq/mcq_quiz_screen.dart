// lib/Features/Quiz/Screens/mcq/mcq_quiz_screen.dart

import 'dart:async';
import 'package:electron_iq/Features/Quiz/Screens/quiz_results_screen.dart';
import 'package:flutter/material.dart';
import '../../../../Datas/quiz_data.dart';
import '../../../../Shared Widgets/Widgets/bouncing_button.dart';
import '../../../../Shared Widgets/Widgets/science_background_painter.dart';

// --- RENAMED THE CLASS HERE ---
class McqQuizScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final bool showSolutions;
  final bool useHints;

  const McqQuizScreen({
    super.key,
    required this.questions,
    required this.showSolutions,
    required this.useHints,
  });

  @override
  State<McqQuizScreen> createState() => _McqQuizScreenState();
}

// --- AND RENAMED THE STATE HERE ---
class _McqQuizScreenState extends State<McqQuizScreen> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;
  late AnimationController _timerController;
  Timer? _questionTimer;
  static const int _questionTimeLimit = 15;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _questionTimeLimit),
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timerController.dispose();
    _questionTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timerController.reset();
    _timerController.forward();
    _questionTimer?.cancel();
    _questionTimer = Timer(const Duration(seconds: _questionTimeLimit), () {
      _handleAnswer('');
    });
  }

  void _handleAnswer(String answer) {
    if (_isAnswered) return;
    _questionTimer?.cancel();
    _timerController.stop();
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
        _startTimer();
      });
    } else {
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
        backgroundColor: const Color(0xFF112240),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          const ScienceBackground(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedBuilder(
                  animation: _timerController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _timerController.value,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      currentQuestion.questionText,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ...currentQuestion.options.map((option) {
                  return _buildOptionButton(option, currentQuestion.correctAnswer);
                }).toList(),
                const Spacer(),
                if (_isAnswered)
                  BouncingButton(
                    onPressed: _nextQuestion,
                    child: Text(
                      _currentQuestionIndex < widget.questions.length - 1 ? 'Next Question' : 'Finish Quiz',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option, String correctAnswer) {
    bool isSelected = _selectedAnswer == option;
    Color buttonColor = const Color(0xFF112240);
    Color borderColor = Colors.transparent;
    if (_isAnswered) {
      if (option == correctAnswer) {
        buttonColor = Colors.green.withOpacity(0.3);
        borderColor = Colors.green;
      } else if (isSelected && option != correctAnswer) {
        buttonColor = Colors.red.withOpacity(0.3);
        borderColor = Colors.red;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BouncingButton(
        onPressed: () => _handleAnswer(option),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          side: BorderSide(color: borderColor, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isAnswered && (option == correctAnswer || isSelected)) ...[
              Icon(
                option == correctAnswer ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: borderColor,
              ),
              const SizedBox(width: 10),
            ],
            Text(option, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}