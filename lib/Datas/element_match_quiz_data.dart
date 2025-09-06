// lib/Datas/element_match_quiz_data.dart

import 'quiz_data.dart'; // Import the shared enum

/// Data class for a single "Element Match" (drag and drop) question.
class FlashCardQuizQuestion {
  final String questionText;
  final String correctElementSymbol;
  final List<String> distractorElementSymbols;
  final QuizDifficulty difficulty;

  const FlashCardQuizQuestion({
    required this.questionText,
    required this.correctElementSymbol,
    required this.distractorElementSymbols,
    required this.difficulty,
  });
}

/// A sample bank of questions for the Element Match quiz.
const List<FlashCardQuizQuestion> flashCardQuizQuestions = [
  // Normal Difficulty
  FlashCardQuizQuestion(
    questionText: 'Which element is the primary component of steel?',
    correctElementSymbol: 'Fe', // Iron
    distractorElementSymbols: ['Au', 'H', 'O'],
    difficulty: QuizDifficulty.normal,
  ),
  FlashCardQuizQuestion(
    questionText: 'Which element has the atomic number 8?',
    correctElementSymbol: 'O', // Oxygen
    distractorElementSymbols: ['N', 'F', 'C'],
    difficulty: QuizDifficulty.normal,
  ),

  // Medium Difficulty
  FlashCardQuizQuestion(
    questionText: 'Which of these is an alkali metal?',
    correctElementSymbol: 'Na', // Sodium
    distractorElementSymbols: ['Ca', 'Al', 'Si'],
    difficulty: QuizDifficulty.medium,
  ),
  FlashCardQuizQuestion(
    questionText: 'This element is a liquid at room temperature.',
    correctElementSymbol: 'Hg', // Mercury
    distractorElementSymbols: ['Br', 'Ga', 'Pb'],
    difficulty: QuizDifficulty.medium,
  ),

  // Hard Difficulty
  FlashCardQuizQuestion(
    questionText: 'Which element is a Lanthanide?',
    correctElementSymbol: 'La', // Lanthanum
    distractorElementSymbols: ['Ac', 'Sc', 'Y'],
    difficulty: QuizDifficulty.hard,
  ),
  FlashCardQuizQuestion(
    questionText: 'This is the most electronegative element.',
    correctElementSymbol: 'F', // Fluorine
    distractorElementSymbols: ['Cl', 'O', 'N'],
    difficulty: QuizDifficulty.hard,
  ),
];
