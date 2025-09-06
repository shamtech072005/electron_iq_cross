// lib/Datas/mcq_quiz_data.dart

import 'quiz_data.dart'; // Import the shared enum

// Data class to hold a single MCQ quiz question
class QuizQuestion {
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final QuizDifficulty difficulty;

  const QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
  });
}

// A sample bank of questions for your MCQ quiz
const List<QuizQuestion> quizQuestions = [
  // Normal Difficulty
  QuizQuestion(
    questionText: 'What is the chemical symbol for Gold?',
    options: ['Au', 'Ag', 'Go', 'Gd'],
    correctAnswer: 'Au',
    difficulty: QuizDifficulty.normal,
  ),
  QuizQuestion(
    questionText: 'Which element has the atomic number 1?',
    options: ['Helium', 'Oxygen', 'Hydrogen', 'Lithium'],
    correctAnswer: 'Hydrogen',
    difficulty: QuizDifficulty.normal,
  ),
  QuizQuestion(
    questionText: 'Which of these is a Noble Gas?',
    options: ['Nitrogen', 'Oxygen', 'Neon', 'Carbon'],
    correctAnswer: 'Neon',
    difficulty: QuizDifficulty.normal,
  ),

  // Medium Difficulty
  QuizQuestion(
    questionText: 'How many valence electrons does Carbon (C) have?',
    options: ['2', '4', '6', '8'],
    correctAnswer: '4',
    difficulty: QuizDifficulty.medium,
  ),
  QuizQuestion(
    questionText: 'Which element is in Group 17, Period 3?',
    options: ['Fluorine', 'Sulfur', 'Argon', 'Chlorine'],
    correctAnswer: 'Chlorine',
    difficulty: QuizDifficulty.medium,
  ),

  // Hard Difficulty
  QuizQuestion(
    questionText: 'What is the block of Lanthanum (La)?',
    options: ['s-block', 'p-block', 'd-block', 'f-block'],
    correctAnswer: 'f-block',
    difficulty: QuizDifficulty.hard,
  ),
  QuizQuestion(
    questionText: 'Which element has the electron configuration [Ar] 3d¹⁰ 4s¹?',
    options: ['Potassium', 'Copper', 'Zinc', 'Calcium'],
    correctAnswer: 'Copper',
    difficulty: QuizDifficulty.hard,
  ),
];