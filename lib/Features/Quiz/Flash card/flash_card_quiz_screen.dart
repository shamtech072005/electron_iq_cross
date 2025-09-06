// lib/Features/Quiz/Flash card/flash_card_quiz_screen.dart
import 'package:electron_iq/Features/Quiz/Screens/quiz_results_screen.dart';
import 'package:electron_iq/Features/Quiz/Widgets/Flash%20Card/element_flash_card.dart';
import 'package:electron_iq/Features/Quiz/Widgets/Flash%20Card/sparkle_animation.dart';
import 'package:flutter/material.dart';
import '../../../../Datas/periodic_table_data.dart';
import '../../../../Datas/quiz_data.dart';
import '../../../../Shared Widgets/Widgets/bouncing_button.dart';
import '../../../../Shared Widgets/Widgets/science_background_painter.dart';

class FlashCardQuizScreen extends StatefulWidget {
  final QuizDifficulty difficulty;
  const FlashCardQuizScreen({super.key, required this.difficulty});
  @override
  State<FlashCardQuizScreen> createState() => _FlashCardQuizScreenState();
}

class _FlashCardQuizScreenState extends State<FlashCardQuizScreen> {
  late List<FlashCardQuizQuestion> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<ChemicalElement> _currentOptions = [];
  bool _isAnswered = false;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    _questions = flashCardQuizQuestions
        .where((q) => q.difficulty == widget.difficulty)
        .toList()
      ..shuffle();
    _prepareCurrentQuestion();
  }

  void _prepareCurrentQuestion() {
    final question = _questions[_currentQuestionIndex];
    final correctElement =
        periodicTableElements.firstWhere((el) => el.symbol == question.correctElementSymbol);
    final distractorElements = question.distractorElementSymbols
        .map((symbol) => periodicTableElements.firstWhere((el) => el.symbol == symbol))
        .toList();
    setState(() {
      _currentOptions = [correctElement, ...distractorElements]..shuffle();
      _isAnswered = false;
      _isCorrect = null;
    });
  }

  void _handleAnswer(ChemicalElement droppedElement) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = droppedElement.symbol == currentQuestion.correctElementSymbol;
    setState(() {
      _isAnswered = true;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _prepareCurrentQuestion();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultsScreen(
            score: _score,
            totalQuestions: _questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1}/${_questions.length}'),
        backgroundColor: const Color(0xFF112240),
      ),
      body: Stack(
        children: [
          const ScienceBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      currentQuestion.questionText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Spacer(),
                // --- THIS IS THE UPDATED DRAGTARGET WIDGET ---
                DragTarget<ChemicalElement>(
                  builder: (context, candidateData, rejectedData) {
                    final bool isHovering = candidateData.isNotEmpty;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _isAnswered
                            ? (_isCorrect!
                                ? Colors.green.withOpacity(0.3)
                                : Colors.red.withOpacity(0.3))
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isAnswered
                              ? (_isCorrect! ? Colors.green : Colors.red)
                              : isHovering
                                  ? Colors.pinkAccent
                                  : Colors.white54,
                          width: isHovering ? 4 : 2,
                        ),
                        boxShadow: isHovering
                            ? [
                                BoxShadow(
                                  color: Colors.pinkAccent.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 4,
                                )
                              ]
                            : [],
                      ),
                      child: Center(
                        child: _isAnswered
                            ? Icon(
                                _isCorrect!
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color: _isCorrect! ? Colors.green : Colors.red,
                                size: 50,
                              )
                            : const Text(
                                'Drop Answer Here',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                      ),
                    );
                  },
                  onWillAccept: (data) => !_isAnswered,
                  onAccept: (droppedElement) {
                    _handleAnswer(droppedElement);
                  },
                ),
                const Spacer(),
                if (_isAnswered)
                  BouncingButton(
                    onPressed: _nextQuestion,
                    child: Text(
                        _currentQuestionIndex < _questions.length - 1
                            ? 'Next Question'
                            : 'Finish Quiz',
                        style: const TextStyle(fontSize: 18)),
                  )
                else
                  SizedBox(
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _currentOptions.map((element) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            // --- THIS IS THE UPDATED DRAGGABLE WIDGET ---
                            child: Draggable<ChemicalElement>(
                              data: element,
                              feedback: Material(
                                type: MaterialType.transparency,
                                child: SizedBox(
                                  height: 140,
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const SparkleAnimation(),
                                      ElementFlashCard(element: element, isGlowing: true),
                                    ],
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: ElementFlashCard(element: element),
                              ),
                              child: ElementFlashCard(element: element),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}