class Question {
  final String question;
  final bool isTrue;

  Question({required this.question, required this.isTrue});
}

class MultipleChoiceQuestion {
  final String question;
  final List<String> options;
  final String correctOption;

  MultipleChoiceQuestion({required this.question, required this.options, required this.correctOption});
}
