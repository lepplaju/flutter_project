import 'dart:convert';
import 'package:http/http.dart' as http;
import './topic.dart';

class TopicsApi {
  Future<List<Topic>> getTopics() async {
    var response =
        await http.get(Uri.parse('https://dad-quiz-api.deno.dev/topics'));

    List<dynamic> topicItems = jsonDecode(response.body);
    return List<Topic>.from(
        topicItems.map((jsonData) => Topic.fromJson(jsonData)));
  }
}
