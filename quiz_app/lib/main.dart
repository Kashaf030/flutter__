import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import the splash screen
import 'subject_selection_screen.dart'; // Import the subject selection screen
import 'quiz_options_screen.dart'; // Import the quiz options screen
import 'true_false_quiz_screen.dart'; // Import the True/False quiz screen
import 'multiple_choice_quiz_screen.dart'; // Import the Multiple Choice quiz screen
import 'quiz_results_screen.dart'; // Import the quiz results screen
import 'question_models.dart'; // Import the question models
import 'user_custom_question_screen.dart'; // Import the custom question screen

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Set the SplashScreen as the home
      routes: {
        // Define routes for other screens
        '/subjectSelection': (context) => SubjectSelectionScreen(),
        '/quizOptions': (context) => QuizOptionsScreen(subject: ''),
        '/trueFalseQuiz': (context) => TrueFalseQuizScreen(subject: ''),
        '/multipleChoiceQuiz': (context) => MultipleChoiceQuizScreen(subject: ''),
        '/quizResults': (context) => QuizResultsScreen(score: 0, total: 0),
        '/customQuestion': (context) => UserCustomQuestionScreen(subject: ''), // Route for the CustomQuestionScreen
      },
    );
  }
}
