import 'package:flutter/material.dart';
import 'question_models.dart';

class UserCustomQuestionScreen extends StatefulWidget {
  final String subject;

  UserCustomQuestionScreen({required this.subject});

  @override
  _UserCustomQuestionScreenState createState() => _UserCustomQuestionScreenState();
}

class _UserCustomQuestionScreenState extends State<UserCustomQuestionScreen> {
  final List<Question> customQuestions = [];
  final TextEditingController questionController = TextEditingController();
  bool isTrue = true;

  void _addQuestion() {
    if (questionController.text.isNotEmpty) {
      setState(() {
        customQuestions.add(Question(question: questionController.text, isTrue: isTrue));
        questionController.clear(); // Clear the text field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Custom Question'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Enter your custom question',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  labelText: 'Your question',
                  labelStyle: TextStyle(color: Colors.white70),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'True',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Radio(
                    value: true,
                    groupValue: isTrue,
                    onChanged: (value) {
                      setState(() {
                        isTrue = value as bool;
                      });
                    },
                    activeColor: Colors.greenAccent,
                  ),
                  Text(
                    'False',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Radio(
                    value: false,
                    groupValue: isTrue,
                    onChanged: (value) {
                      setState(() {
                        isTrue = value as bool;
                      });
                    },
                    activeColor: Colors.redAccent,
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addQuestion,
                child: Text(
                  'Add Question',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Card(
                  color: Colors.white.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: customQuestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            customQuestions[index].question,
                            style: TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                          subtitle: Text(
                            customQuestions[index].isTrue ? 'True' : 'False',
                            style: TextStyle(
                              color: customQuestions[index].isTrue
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, customQuestions);
                },
                child: Text(
                  'Finish',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
