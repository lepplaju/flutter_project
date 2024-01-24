import 'dart:convert';
import 'package:http/http.dart' as http;
import './question.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuestionsApi {
  Future<Question> getRandomQuestion(topicId) async {
    var response = await http.get(
        Uri.parse('${dotenv.env['API_BASE_URL']}/topics/$topicId/questions'));
    final questionItem = jsonDecode(response.body);
    return Question.fromJson(questionItem);
  }

  Future<bool> submitAnswer(int topicId, int questionId, String answer) async {
    var response = await http.post(
        Uri.parse(
            '${dotenv.env['API_BASE_URL']}/topics/$topicId/questions/$questionId/answers'),
        body: jsonEncode({'answer': answer}),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) {
      throw Exception('Failed to submit answer');
    }
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    bool correct = jsonMap['correct'];
    return correct;
  }
}
