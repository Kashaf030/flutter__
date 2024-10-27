import 'package:flutter/material.dart';
import 'question_models.dart'; // Import the MultipleChoiceQuestion model.

class CustomQuestionScreen extends StatefulWidget {
  @override
  _CustomQuestionScreenState createState() => _CustomQuestionScreenState();
}

class _CustomQuestionScreenState extends State<CustomQuestionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  final TextEditingController _correctOptionController = TextEditingController();

  void _addQuestion() {
    if (_formKey.currentState!.validate()) {
      // Creating a new custom question
      MultipleChoiceQuestion customQuestion = MultipleChoiceQuestion(
        question: _questionController.text,
        options: [
          _option1Controller.text,
          _option2Controller.text,
          _option3Controller.text,
          _option4Controller.text,
        ],
        correctOption: _correctOptionController.text,
      );

      Navigator.pop(context, customQuestion);
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the screen is closed to free memory
    _questionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    _option4Controller.dispose();
    _correctOptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Custom Question'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _option1Controller,
                decoration: InputDecoration(
                  labelText: 'Option 1',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter option 1';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _option2Controller,
                decoration: InputDecoration(
                  labelText: 'Option 2',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter option 2';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _option3Controller,
                decoration: InputDecoration(
                  labelText: 'Option 3',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter option 3';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _option4Controller,
                decoration: InputDecoration(
                  labelText: 'Option 4',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter option 4';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _correctOptionController,
                decoration: InputDecoration(
                  labelText: 'Correct Option',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the correct option';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _addQuestion,
                child: Text('Add Question'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
