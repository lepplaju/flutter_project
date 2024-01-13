import 'package:flutter/material.dart';
import 'package:quiz_application/helpers/questions_api.dart';
import 'package:quiz_application/helpers/shared_pref_helper.dart';
import 'package:quiz_application/widgets/custom_dialog.dart';
import '../helpers/question.dart';

class GenericPracticePage extends StatefulWidget {
  const GenericPracticePage({Key? key}) : super(key: key);

  @override
  _GenericPracticePageState createState() => _GenericPracticePageState();
}

class _GenericPracticePageState extends State<GenericPracticePage> {
  QuestionsApi questionsApi = QuestionsApi();
  int? currentTopicId;
  Question? currentQuestion;
  int? _selectedOption;
  String? _selectedOptionText;
  bool _answeredCorrectly = false;

  getQuestion() async {
    currentTopicId = SharedPrefHelper.getMinimumValue();
    print("Getting the question... from Topicid: $currentTopicId");
    Question question = await questionsApi.getRandomQuestion(currentTopicId);
    setState(() {
      _answeredCorrectly = false;
      currentQuestion = question;
      _selectedOption = null;
      _selectedOptionText = null;
    });
  }

  showCustomDialog(bool? correct) {
    DialogController().showCustomDialog(context, correct);
  }

  submitAnswer() async {
    if (_selectedOption == null) {
      showCustomDialog(null);
      return;
    }
    bool ans = await questionsApi.submitAnswer(
        currentTopicId!, currentQuestion!.id, _selectedOptionText!);
    showCustomDialog(ans);
    if (ans) {
      await SharedPrefHelper.incrementValue(currentTopicId!);
    }
    setState(() {
      _answeredCorrectly = ans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: currentQuestion == null
            ? Column(children: [
                Text(
                    "Get a question from the topic that the user has the least correct answers."),
                ElevatedButton(
                    onPressed: getQuestion, child: Text("get Question"))
              ])
            : Column(
                children: [
                  Text('Question: ${currentQuestion!.question}'),
                  currentQuestion!.imagePath != null
                      ? Image.network(currentQuestion!.imagePath!)
                      : const SizedBox.shrink(),
                  Column(
                    children:
                        currentQuestion!.options.asMap().entries.map((entry) {
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
                  _answeredCorrectly
                      ? ElevatedButton(
                          onPressed: getQuestion, child: Text("Next Question"))
                      : ElevatedButton(
                          child: const Text("submit answer"),
                          onPressed: submitAnswer,
                        ),
                ],
              ));
  }
}
