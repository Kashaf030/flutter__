import 'package:flutter/material.dart';
import 'question_models.dart'; // Ensure this path is correct
import 'quiz_results_screen.dart'; // Ensure this screen exists.
import 'custom_question_screen.dart'; // A new screen to add custom questions.

class MultipleChoiceQuizScreen extends StatefulWidget {
  final String subject;

  MultipleChoiceQuizScreen({required this.subject});

  @override
  _MultipleChoiceQuizScreenState createState() => _MultipleChoiceQuizScreenState();
}

class _MultipleChoiceQuizScreenState extends State<MultipleChoiceQuizScreen> {
  late List<MultipleChoiceQuestion> questions;
  int currentQuestionIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    questions = _getQuestionsForSubject(widget.subject);
  }

  // List of subject-specific questions
  List<MultipleChoiceQuestion> _getQuestionsForSubject(String subject) {
    if (subject == 'Flutter') {
      return [
        MultipleChoiceQuestion(
          question: 'What is Flutter primarily used for?',
          options: ['Web Development', 'Mobile App Development', 'Data Science', 'Game Development'],
          correctOption: 'Mobile App Development',
        ),
        MultipleChoiceQuestion(
          question: 'Which language is used to develop Flutter apps?',
          options: ['Java', 'Kotlin', 'Dart', 'Swift'],
          correctOption: 'Dart',
        ),
        MultipleChoiceQuestion(
          question: 'What is the widget used for layout in Flutter?',
          options: ['Container', 'Text', 'Row', 'Column'],
          correctOption: 'Container',
        ),
        MultipleChoiceQuestion(
          question: 'Which company developed Flutter?',
          options: ['Apple', 'Microsoft', 'Google', 'Facebook'],
          correctOption: 'Google',
        ),
        MultipleChoiceQuestion(
          question: 'What is the command to create a new Flutter project?',
          options: ['flutter create', 'flutter build', 'flutter init', 'flutter start'],
          correctOption: 'flutter create',
        ),
      ];
    } else if (subject == 'Dart') {
      return [
        MultipleChoiceQuestion(
          question: 'Which company developed Dart?',
          options: ['Microsoft', 'Google', 'Apple', 'Oracle'],
          correctOption: 'Google',
        ),
        MultipleChoiceQuestion(
          question: 'What type of language is Dart?',
          options: ['Statically Typed', 'Dynamically Typed', 'Both', 'None'],
          correctOption: 'Statically Typed',
        ),
        MultipleChoiceQuestion(
          question: 'Which keyword is used to declare a constant variable in Dart?',
          options: ['var', 'const', 'let', 'static'],
          correctOption: 'const',
        ),
        MultipleChoiceQuestion(
          question: 'What is the extension of Dart files?',
          options: ['.dart', '.js', '.java', '.py'],
          correctOption: '.dart',
        ),
        MultipleChoiceQuestion(
          question: 'Which feature of Dart allows you to define a function within another function?',
          options: ['Anonymous Functions', 'Nested Functions', 'Callbacks', 'Closures'],
          correctOption: 'Nested Functions',
        ),
      ];
    } else if (subject == 'JavaScript') {
      return [
        MultipleChoiceQuestion(
          question: 'Which company developed JavaScript?',
          options: ['Microsoft', 'Google', 'Netscape', 'Mozilla'],
          correctOption: 'Netscape',
        ),
        MultipleChoiceQuestion(
          question: 'Which keyword is used to define variables in ES6?',
          options: ['var', 'let', 'int', 'float'],
          correctOption: 'let',
        ),
        MultipleChoiceQuestion(
          question: 'Which method is used to parse a string to an integer in JavaScript?',
          options: ['int()', 'parseInt()', 'parse()', 'parseInteger()'],
          correctOption: 'parseInt()',
        ),
        MultipleChoiceQuestion(
          question: 'What is the output of "typeof null" in JavaScript?',
          options: ['object', 'null', 'undefined', 'string'],
          correctOption: 'object',
        ),
        MultipleChoiceQuestion(
          question: 'Which method is used to select elements by their ID in JavaScript?',
          options: ['getElementById()', 'querySelector()', 'getElementsByClassName()', 'getElementByTagName()'],
          correctOption: 'getElementById()',
        ),
      ];
    } else if (subject == 'Python') {
      return [
        MultipleChoiceQuestion(
          question: 'What is the file extension for Python files?',
          options: ['.py', '.java', '.js', '.dart'],
          correctOption: '.py',
        ),
        MultipleChoiceQuestion(
          question: 'Which of the following is used to define a function in Python?',
          options: ['func', 'def', 'function', 'lambda'],
          correctOption: 'def',
        ),
        MultipleChoiceQuestion(
          question: 'Which data structure is used to store multiple values in a single variable in Python?',
          options: ['List', 'Array', 'Stack', 'Queue'],
          correctOption: 'List',
        ),
        MultipleChoiceQuestion(
          question: 'Which keyword is used to create a class in Python?',
          options: ['object', 'class', 'struct', 'define'],
          correctOption: 'class',
        ),
        MultipleChoiceQuestion(
          question: 'How do you insert a comment in Python?',
          options: ['# comment', '// comment', '/* comment */', '<!-- comment -->'],
          correctOption: '# comment',
        ),
      ];
    } else {
      return [];
    }
  }

  void checkAnswer(String selectedOption) {
    setState(() {
      if (selectedOption == questions[currentQuestionIndex].correctOption) {
        score++;
      }

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizResultsScreen(score: score, total: questions.length),
            ),
          );
        });
      }
    });
  }

  void _navigateToCustomQuestionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomQuestionScreen()),
    ).then((customQuestion) {
      if (customQuestion != null) {
        setState(() {
          questions.add(customQuestion);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Multiple Choice Quiz - ${widget.subject}',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: questions.isEmpty
          ? Center(
        child: Text(
          'No questions available.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      )
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1} of ${questions.length}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    questions[currentQuestionIndex].question,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              ...questions[currentQuestionIndex].options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => checkAnswer(option),
                    child: Text(
                      option,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToCustomQuestionScreen,
                child: Text('Add Custom Question'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
