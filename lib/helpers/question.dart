class Question {
  final int id;
  final String question;
  final List<dynamic> options;
  final String answerPostPath;
  String? imagePath;

  Question.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'],
        question = jsonData['question'],
        options = jsonData['options'],
        answerPostPath = jsonData['answer_post_path'],
        imagePath =
            jsonData.containsKey('image_url') ? jsonData['image_url'] : null;
}
