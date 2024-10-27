import 'package:flutter/material.dart';
import 'question_models.dart';
import 'quiz_results_screen.dart';
import 'user_custom_question_screen.dart'; // Ensure this path is correct

class TrueFalseQuizScreen extends StatefulWidget {
  final String subject;

  TrueFalseQuizScreen({required this.subject});

  @override
  _TrueFalseQuizScreenState createState() => _TrueFalseQuizScreenState();
}

class _TrueFalseQuizScreenState extends State<TrueFalseQuizScreen> {
  late List<Question> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  bool? answerStatus;
  static List<Question> customQuestions = []; // Static list to hold custom questions

  @override
  void initState() {
    super.initState();
    questions = _getQuestionsForSubject(widget.subject);
    // Combine custom questions with predefined ones
    questions.addAll(customQuestions);
    if (questions.isEmpty) {
      questions.add(Question(question: 'No questions available.', isTrue: false));
    }
  }

  List<Question> _getQuestionsForSubject(String subject) {
    switch (subject) {
      case 'Flutter':
        return [
          Question(question: 'Flutter is an SDK for mobile development.', isTrue: true),
          Question(question: 'Flutter uses JavaScript as its primary programming language.', isTrue: false),
          Question(question: 'Flutter supports hot reload functionality.', isTrue: true),
          Question(question: 'Flutter can be used to build web applications.', isTrue: true),
          Question(question: 'Flutter was developed by Google.', isTrue: true),
        ];
      case 'Dart':
        return [
          Question(question: 'Dart is an object-oriented programming language.', isTrue: true),
          Question(question: 'Dart is primarily used for backend development.', isTrue: false),
          Question(question: 'Dart supports both Just-in-Time (JIT) and Ahead-of-Time (AOT) compilation.', isTrue: true),
          Question(question: 'Dart uses semicolons to end statements.', isTrue: true),
          Question(question: 'Dart does not support null safety.', isTrue: false),
        ];
      case 'JavaScript':
        return [
          Question(question: 'JavaScript is a client-side scripting language.', isTrue: true),
          Question(question: 'JavaScript can be used for server-side programming with Node.js.', isTrue: true),
          Question(question: 'JavaScript is a compiled language.', isTrue: false),
          Question(question: 'JavaScript supports object-oriented programming.', isTrue: true),
          Question(question: 'JavaScript was created by Microsoft.', isTrue: false),
        ];
      case 'Python':
        return [
          Question(question: 'Python is a high-level programming language.', isTrue: true),
          Question(question: 'Python supports multiple programming paradigms, including procedural and object-oriented programming.', isTrue: true),
          Question(question: 'Python is known for its extensive use in data analysis and machine learning.', isTrue: true),
          Question(question: 'Python requires explicit declaration of variable types.', isTrue: false),
          Question(question: 'Python was developed in the 1990s.', isTrue: true),
        ];
      default:
        return [];
    }
  }

  void checkAnswer(bool userAnswer) {
    setState(() {
      if (userAnswer == questions[currentQuestionIndex].isTrue) {
        score++;
        answerStatus = true;
      } else {
        answerStatus = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('True/False Quiz - ${widget.subject}'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
                    style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => checkAnswer(true),
                    child: Text('True', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => checkAnswer(false),
                    child: Text('False', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (answerStatus != null)
                Text(
                  answerStatus! ? 'Correct!' : 'Wrong!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: answerStatus! ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserCustomQuestionScreen(subject: widget.subject),
                    ),
                  );

                  // Update customQuestions with the result if not null
                  if (result != null) {
                    setState(() {
                      customQuestions = result; // Update with the returned list of custom questions
                      questions.addAll(customQuestions); // Combine custom questions again
                    });
                  }
                },
                child: Text('Add Custom Question', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
