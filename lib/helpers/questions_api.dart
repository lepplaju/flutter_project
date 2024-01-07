import 'dart:convert';
import 'package:http/http.dart' as http;
import './question.dart';

class QuestionsApi {
  Future<Question> getRandomQuestion(topicId) async {
    var response = await http.get(
        Uri.parse('https://dad-quiz-api.deno.dev/topics/$topicId/questions'));
    final questionItem = jsonDecode(response.body);
    return Question.fromJson(questionItem);
  }
}
