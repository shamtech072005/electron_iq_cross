// lib/Features/Quiz/Screens/quiz_menu_screen.dart

import 'package:electron_iq/Features/Quiz/Flash%20card/flash_card_quiz_screen.dart';
import 'package:electron_iq/Features/Quiz/Mcq/mcq_quiz_screen.dart';
import 'package:flutter/material.dart';
import '../../../Datas/quiz_data.dart';
import '../../../Shared Widgets/Widgets/bouncing_button.dart';
import '../../../Shared Widgets/Widgets/science_background_painter.dart';

enum QuizType { mcq, elementMatch }

class QuizMenuScreen extends StatefulWidget {
  const QuizMenuScreen({super.key});

  @override
  State<QuizMenuScreen> createState() => _QuizMenuScreenState();
}

class _QuizMenuScreenState extends State<QuizMenuScreen> {
  QuizType _selectedQuizType = QuizType.mcq;
  QuizDifficulty _selectedDifficulty = QuizDifficulty.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Quiz Mode'),
        backgroundColor: const Color(0xFF112240),
      ),
      body: Stack(
        children: [
          const ScienceBackground(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Define breakpoints for different screen sizes
                const double mobileBreakpoint = 600;
                const double tabletBreakpoint = 1100;
                
                double cardHeight;
                double fontSize;

                if (constraints.maxWidth > tabletBreakpoint) {
                  // Web layout
                  cardHeight = 500;
                  fontSize = 18;
                } else if (constraints.maxWidth > mobileBreakpoint) {
                  // Tablet layout
                  cardHeight = 400;
                  fontSize = 16;
                } else {
                  // Mobile layout (responsive height)
                  double cardWidth = (constraints.maxWidth - 16) / 2;
                  cardHeight = cardWidth * 1.4;
                  fontSize = 14;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildQuizTypeCard(
                            title: 'MCQ Challenge',
                            imagePath: 'assets/quiz_images/mcq_challenge.png',
                            icon: Icons.format_list_bulleted_rounded,
                            type: QuizType.mcq,
                            height: cardHeight,
                            fontSize: fontSize,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildQuizTypeCard(
                            title: 'Element Match',
                            imagePath: 'assets/quiz_images/element_match.png',
                            icon: Icons.touch_app_rounded,
                            type: QuizType.elementMatch,
                            height: cardHeight,
                            fontSize: fontSize,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    _buildSectionHeader('Select Difficulty'),
                    const SizedBox(height: 16),
                    SegmentedButton<QuizDifficulty>(
                      segments: const [
                        ButtonSegment(
                            value: QuizDifficulty.normal, label: Text('Normal')),
                        ButtonSegment(
                            value: QuizDifficulty.medium, label: Text('Medium')),
                        ButtonSegment(
                            value: QuizDifficulty.hard, label: Text('Hard')),
                      ],
                      selected: {_selectedDifficulty},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _selectedDifficulty = newSelection.first;
                        });
                      },
                      style: SegmentedButton.styleFrom(
                        backgroundColor: const Color(0xFF112240),
                        foregroundColor: Colors.white70,
                        selectedForegroundColor: Colors.white,
                        selectedBackgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),

                    const Spacer(),

                    BouncingButton(
                      onPressed: () {
                        if (_selectedQuizType == QuizType.mcq) {
                          final questions = quizQuestions
                              .where((q) => q.difficulty == _selectedDifficulty)
                              .toList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => McqQuizScreen( // Assuming you've renamed QuizScreen
                                questions: questions,
                                showSolutions: true,
                                useHints: false,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlashCardQuizScreen(difficulty: _selectedDifficulty),
                            ),
                          );
                        }
                      },
                      child: const Text('Start Quiz', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizTypeCard({
    required String title,
    required String imagePath,
    required IconData icon,
    required QuizType type,
    required double height,
    required double fontSize,
  }) {
    final bool isSelected = _selectedQuizType == type;
    final double iconSize = fontSize + 4;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedQuizType = type;
        });
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? Colors.tealAccent : Colors.white24,
            width: isSelected ? 3 : 1,
          ),
        ),
        elevation: isSelected ? 8 : 2,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: height,
              width: double.infinity,
            ),
            Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.5, 0.7, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Colors.tealAccent : Colors.white70,
                    size: iconSize,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Colors.tealAccent,
                      size: iconSize,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

