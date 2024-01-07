import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_application/helpers/questions_api.dart';
import '../helpers/providers.dart';
import '../widgets/top_bar.dart';
import '../helpers/question.dart';
import '../helpers/questions_api.dart';

class QuestionPage extends StatefulWidget {
  final int topicId;
  QuestionPage(this.topicId);
  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

//Widget build(BuildContext context) {
//    return ProviderScope(
//        child: Scaffold(appBar: TopBar(), body: QuestionDisplayer(topicId)));
//  }

class _QuestionPageState extends State<QuestionPage> {
  Question? _question;
  getQuestion() async {
    final questionApi = QuestionsApi();
    Question question = await questionApi.getRandomQuestion(widget.topicId);
    setState(() {
      _question = question;
      print("question!");
      print(question.options);
    });
  }

  @override
  void initState() {
    super.initState();
    getQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(),
        body: Container(
            margin: EdgeInsets.all(20),
            child: Container(
              child: _question != null
                  ? Column(children: [
                      Text('Question: ${_question!.question}'),
                      for (var option in _question!.options) Text(option)
                    ])
                  : Text('Loading...'),
            )));
  }
}
