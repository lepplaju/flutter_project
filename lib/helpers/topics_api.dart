import 'dart:convert';
import 'package:http/http.dart' as http;

class TopicsApi {
  Future<List<String>> getTopics() async {
    var response =
        await http.get(Uri.parse('https://dad-quiz-api.deno.dev/topics'));

    List<dynamic> topics = jsonDecode(response.body);
    return List<String>.from(topics.map(
      (jsonData) => (jsonData['name']),
    ));
  }
}
