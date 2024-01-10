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

class _QuestionPageState extends State<QuestionPage> {
  bool _answeredCorrectly = false;
  Question? _question;
  int? _selectedOption;
  String? _selectedOptionText;
  final questionApi = QuestionsApi();
  getQuestion() async {
    Question question = await questionApi.getRandomQuestion(widget.topicId);
    setState(() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _selectedOption = null;
      _selectedOptionText = null;
      _answeredCorrectly = false;
      _question = question;
    });
  }

  @override
  void initState() {
    super.initState();
    getQuestion();
  }

  answerQuestion() async {
    bool ans = await questionApi.submitAnswer(
        widget.topicId, _question!.id, _selectedOptionText!);
    _showAnswerFeedback(ans);
    setState(() {
      _answeredCorrectly = ans;
    });
    // Need to display a red box if the answer is wrong and a green box if the answer is correct
  }

  _showAnswerFeedback(bool correct) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.only(bottom: 100.0),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Text(
                          correct
                              ? 'Your answer is correct!'
                              : 'Your answer is wrong!',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ))))
          ]),
      backgroundColor: correct ? Colors.green : Colors.red,
      elevation: 25,
      duration: Duration(seconds: 25),
    ));
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
                                  _selectedOptionText = option;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        ElevatedButton(
                          child: Text("submit answer"),
                          onPressed: () => answerQuestion(),
                        ),
                        if (_answeredCorrectly)
                          ElevatedButton(
                            onPressed: () => getQuestion(),
                            child: Text('Next Question'),
                          ),
                      ],
                    )
                  : Text('Loading...'),
            )));
  }
}
