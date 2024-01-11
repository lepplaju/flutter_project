import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './question_page.dart';
import '../widgets/top_bar.dart';

class QuestionDisplay extends StatelessWidget {
  final int topicId;
  const QuestionDisplay(this.topicId, {super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: Scaffold(appBar: const TopBar(), body: QuestionPage(topicId)));
  }
}
