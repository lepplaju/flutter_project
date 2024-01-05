import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/top_bar.dart';

getTopics() {
  // topicId = http.get(https://dad-quiz-api.deno.dev/topics);
  // questions = http.get(https://dad-quiz-api.deno.dev/topics/:topicId/questions);

  // correctAns = http.get(https://dad-quiz-api.deno.dev/topics/:topicId/questions/:questionId/answers);
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext) {
    return Scaffold(appBar: TopBar(), body: Text('Hello World??'));
  }
}
