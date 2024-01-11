import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/providers.dart';
import '../helpers/topic.dart';

class TopicsDisplayer extends ConsumerWidget {
  const TopicsDisplayer({super.key});

  double calculateMaxWidth(List<Topic> topics, BuildContext context) {
    double maxWidth = 0.0;
    for (Topic topic in topics) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: topic.name,
            style:
                const TextStyle(fontSize: 16.0)), // Adjust font size as needed
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: MediaQuery.of(context).size.width);

      double width = textPainter.width;
      if (width > maxWidth) {
        maxWidth = width;
      }
    }

    return maxWidth;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicProvider);

    final double maxWidth = calculateMaxWidth(topics, context);
    final items = List<Widget>.from(topics.map((topic) => Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 18.0), // Adjusting vertical spacing
        child: ElevatedButton(
            onPressed: () => context.go('/topics/${topic.id}'),
            child: SizedBox(
              width: maxWidth,
              height: 50,
              child: Center(child: Text(topic.name)),
            )))));
    return Center(
        child: Column(
      children: [...items],
    ));
  }
}
