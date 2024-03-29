import 'package:flutter/material.dart';
import 'package:quiz_application/helpers/questions_api.dart';
import 'package:quiz_application/helpers/shared_pref_helper.dart';
import 'package:quiz_application/widgets/custom_dialog.dart';
import '../helpers/question.dart';

class GenericPracticePage extends StatefulWidget {
  const GenericPracticePage({Key? key}) : super(key: key);

  @override
  State<GenericPracticePage> createState() => _GenericPracticePageState();
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
            ? Center(
                child: Container(
                    width: 300,
                    child: Column(children: [
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                              style: TextStyle(fontSize: 20),
                              "Pressing the button will give you a question from a topic that you have the fewest correct answers.")),
                      ElevatedButton(
                          key: const ValueKey('get_question_button'),
                          onPressed: getQuestion,
                          child: const Text("Get question"))
                    ])))
            : Column(
                key: const ValueKey('question_column'),
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        currentQuestion!.question,
                        style: TextStyle(fontSize: 20),
                      )),
                  currentQuestion!.imagePath != null
                      ? Image.network(currentQuestion!.imagePath!)
                      : const SizedBox.shrink(),
                  Center(
                    child: Container(
                      width: 200,
                      child: currentQuestion != null
                          ? Column(
                              children: currentQuestion!.options
                                  .asMap()
                                  .entries
                                  .map((entry) {
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
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  _answeredCorrectly
                      ? ElevatedButton(
                          key: const ValueKey('next_question_button'),
                          onPressed: getQuestion,
                          child: const Text("Next Question"))
                      : ElevatedButton(
                          key: const ValueKey('submit_answer_button'),
                          onPressed: submitAnswer,
                          child: const Text("submit answer"),
                        ),
                ],
              ));
  }
}
