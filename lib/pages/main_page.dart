import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/topics_displayer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
        child: Scaffold(appBar: TopBar(), body: TopicsDisplayer()));
  }
}
