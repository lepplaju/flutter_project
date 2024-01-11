import 'package:quiz_application/helpers/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:quiz_application/helpers/questions_api.dart';
import '../helpers/question.dart';

// Dynamically show questions based on the id of the topic chosen from the UI.
class QuestionPage extends StatefulWidget {
  final int topicId;
  const QuestionPage(this.topicId, {super.key});
  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  bool _answeredCorrectly = false;
  Question? _question;
  int? _selectedOption;
  String? _selectedOptionText;
  int? count;
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
    count = SharedPrefHelper.getValue();
  }

  // Submit the answer to the question
  answerQuestion() async {
    bool ans = await questionApi.submitAnswer(
        widget.topicId, _question!.id, _selectedOptionText!);
    if (ans) {
      await SharedPrefHelper.incrementValue();
      count = SharedPrefHelper.getValue();
    }
    _showAnswerFeedback(ans);
    setState(() {
      _answeredCorrectly = ans;
    });
  }

  // Show popup notification after submitting an answer
  _showAnswerFeedback(bool correct) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.only(bottom: 100.0),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Text(
                          correct
                              ? 'Your answer is correct! $count'
                              : 'Your answer is wrong!',
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white),
                        ))))
          ]),
      backgroundColor: correct ? Colors.green : Colors.red,
      elevation: 25,
      duration: const Duration(seconds: 25),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Container(
          child: _question != null
              ? Column(
                  children: [
                    Text('Question: ${_question!.question}'),
                    Column(
                      // Dynamically generate and display the buttons based on the number of options given from the API.
                      children: _question!.options.asMap().entries.map((entry) {
                        int index = entry.key;
                        String option = entry.value;

                        return RadioListTile<int>(
                          title: Text(option),
                          value: index,
                          groupValue: _selectedOption,
                          onChanged: (int? value) {
                            setState(() {
                              // Keep track of the selected option
                              _selectedOption = value;
                              _selectedOptionText = option;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      child: const Text("submit answer"),
                      onPressed: () => answerQuestion(),
                    ),
                    if (_answeredCorrectly)
                      ElevatedButton(
                        onPressed: () => getQuestion(),
                        child: const Text('Next Question'),
                      ),
                  ],
                )
              : const Text('Loading...'),
        ));
  }
}
