class Question {
  final int id;
  final String question;
  final List<dynamic> options;
  final String answerPostPath;

  Question.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'],
        question = jsonData['question'],
        options = jsonData['options'],
        answerPostPath = jsonData['answer_post_path'];
}
