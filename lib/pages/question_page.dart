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
  int? _selectedOption;
  getQuestion() async {
    final questionApi = QuestionsApi();
    Question question = await questionApi.getRandomQuestion(widget.topicId);
    setState(() {
      _question = question;
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
                  ? Column(
                      children: [
                        Text('Question: ${_question!.question}'),
                        Column(
                          children:
                              _question!.options.asMap().entries.map((entry) {
                            int index = entry.key;
                            String option = entry.value;

                            return RadioListTile<int>(
                              title: Text(option),
                              value: index,
                              groupValue: _selectedOption,
                              onChanged: (int? value) {
                                setState(() {
                                  _selectedOption = value;
                                  print('in set State');
                                });
                                if (value != null) {
                                  String selectedOptionText =
                                      _question!.options[value];
                                  print(selectedOptionText);
                                }
                              },
                            );
                          }).toList(),
                        ),
                        ElevatedButton(
                          child: Text("submit answer"),
                          onPressed: () => print("TODO functionality"),
                        )
                      ],
                    )
                  : Text('Loading...'),
            )));
  }
}
