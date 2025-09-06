// lib/Datas/quiz_data.dart

// --- FIX: Directives moved to the top of the file ---
// Exporting the other files so they can be imported from this central location.
export 'mcq_quiz_data.dart';
export 'element_match_quiz_data.dart';

// This enum is shared by both quiz types and is now declared AFTER the directives.
enum QuizDifficulty {
  normal,
  medium,
  hard,
}