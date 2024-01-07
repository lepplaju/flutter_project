import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/top_bar.dart';
import '../widgets/topics_displayer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/providers.dart';
import 'package:go_router/go_router.dart';

getTopics() {
  // topicId = http.get(https://dad-quiz-api.deno.dev/topics);
  // questions = http.get(https://dad-quiz-api.deno.dev/topics/:topicId/questions);

  // correctAns = http.get(https://dad-quiz-api.deno.dev/topics/:topicId/questions/:questionId/answers);
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: Scaffold(appBar: TopBar(), body: TopicsDisplayer()));
  }
}
/*
class TopicsDisplayer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicProvider);
    final items = List<Widget>.from(topics.map((topic) => ElevatedButton(
        onPressed: () => context.go('/topics/${topic.id}'),
        child: Text(topic.name))));
    return Center(
        child: Column(
      children: [...items],
    ));
  }
}
*/