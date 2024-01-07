import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/providers.dart';

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
