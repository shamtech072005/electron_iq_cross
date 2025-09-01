// lib/Screens/quiz_menu_screen.dart

import 'package:flutter/material.dart';

import '../Quiz/quiz_data.dart';
import 'quiz_screen.dart'; // We will create this next

class QuizMenuScreen extends StatefulWidget {
  const QuizMenuScreen({super.key});

  @override
  State<QuizMenuScreen> createState() => _QuizMenuScreenState();
}

class _QuizMenuScreenState extends State<QuizMenuScreen> {
  QuizDifficulty _selectedDifficulty = QuizDifficulty.normal;
  bool _showSolutions = true;
  bool _useHints = false; // "Blubs" interpreted as Hints/Lightbulbs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2125),
      appBar: AppBar(
        title: const Text('Quiz Mode Settings'),
        backgroundColor: const Color(0xFF2C2F33),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Difficulty Selector ---
            const Text('Select Difficulty', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SegmentedButton<QuizDifficulty>(
              segments: const [
                ButtonSegment(value: QuizDifficulty.normal, label: Text('Normal')),
                ButtonSegment(value: QuizDifficulty.medium, label: Text('Medium')),
                ButtonSegment(value: QuizDifficulty.hard, label: Text('Hard')),
              ],
              selected: {_selectedDifficulty},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _selectedDifficulty = newSelection.first;
                });
              },
              style: SegmentedButton.styleFrom(
                backgroundColor: const Color(0xFF2C2F33),
                foregroundColor: Colors.white,
                selectedForegroundColor: Colors.white,
                selectedBackgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 40),

            // --- Options ---
            const Text('Options', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Show Solutions', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Display correct answer after each question', style: TextStyle(color: Colors.white70)),
              value: _showSolutions,
              onChanged: (newValue) {
                setState(() {
                  _showSolutions = newValue;
                });
              },
              activeColor: Theme.of(context).primaryColor,
              tileColor: const Color(0xFF2C2F33),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Enable Hints (Bulbs)', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Allow using hints during the quiz', style: TextStyle(color: Colors.white70)),
              value: _useHints,
              onChanged: (newValue) {
                setState(() {
                  _useHints = newValue;
                });
              },
              activeColor: Theme.of(context).primaryColor,
              tileColor: const Color(0xFF2C2F33),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),

            const Spacer(), // Pushes the button to the bottom

            // --- Start Button ---
            ElevatedButton(
              onPressed: () {
                // Filter questions based on selected difficulty
                final questions = quizQuestions
                    .where((q) => q.difficulty == _selectedDifficulty)
                    .toList();

                // Navigate to the actual quiz screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      questions: questions,
                      showSolutions: _showSolutions,
                      useHints: _useHints,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Start Quiz', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}