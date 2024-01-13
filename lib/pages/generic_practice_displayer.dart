import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/top_bar.dart';
import './generic_practice_page.dart';

// This page will display a question from the topic that the user has the least correct answers.

class GenericPracticeDisplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: Scaffold(appBar: const TopBar(), body: GenericPracticePage()));
  }
}
