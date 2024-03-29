import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:quiz_application/helpers/shared_pref_helper.dart';
import 'package:quiz_application/pages/generic_practice_displayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  setUpAll(() {
    var baseUrl = dotenv.env['API_BASE_URL']!;
    nock.defaultBase = baseUrl;
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });
  testWidgets(
      "Generic practice shows question from topic with fewest correct answers",
      (tester) async {
    //var baseUrl = dotenv.env['API_BASE_URL'];
    final interceptor = nock.get('/topics')
      ..reply(
        200,
        [
          {
            "id": 1,
            "name": "fun facts",
            "question_path": "/topics/1/questions"
          },
          {"id": 2, "name": "movies", "question_path": "/topics/2/questions"},
          {"id": 3, "name": "games", "question_path": "/topics/3/questions"},
          {
            "id": 4,
            "name": "Miscellaneous",
            "question_path": "/topics/4/questions"
          }
        ],
      );

    // This api call should happen when we fetch the first question (since topic with id 3 has the fewest correct answers)
    // ignore: unused_local_variable
    final questionInterceptor = nock.get('/topics/3/questions')
      ..reply(
        200,
        {
          "id": 3,
          "question": "this question is about games",
          "options": ["wrong", "wrong", "correct", "wrong"],
          "answer_post_path": "/topics/3/questions/3/answers"
        },
      );
    // ignore: unused_local_variable
    final questionInterceptor2 = nock.get('/topics/2/questions')
      ..reply(
        200,
        {
          "id": 3,
          "question": "Movie Mania",
          "options": ["wrong", "wrong", "wrong", "correct"],
          "answer_post_path": "/topics/2/questions/3/answers"
        },
      );

    // ignore: unused_local_variable
    final answerInterceptor =
        nock.post('/topics/3/questions/3/answers', {'answer': 'correct'})
          ..reply(
            200,
            {
              "correct": true,
            },
          )
          ..onReply(() {});
    SharedPreferences.setMockInitialValues({
      'fun facts': 4,
      'movies': 3,
      'games': 1,
      'Miscellaneous': 4,
      'all': 12
    });
    await SharedPrefHelper.init();

    const myApp = MaterialApp(home: GenericPracticeDisplayer());
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    // The initial generic_practice_page is just information about what is going to happen. We need to press a button to proceed to the question
    var buttonFinder = find.byKey(const ValueKey("get_question_button"));
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();
    // Now we should be on the question page

    var questionColumn = find.byKey(const ValueKey("question_column"));
    expect(questionColumn, findsOneWidget);
    final questionText = find.descendant(
        of: questionColumn,
        matching: find.textContaining("this question is about games"));
    expect(questionText, findsOneWidget);
    final answerRadioTile =
        find.descendant(of: questionColumn, matching: find.text('correct'));
    expect(answerRadioTile, findsOneWidget);
    await tester.tap(answerRadioTile);
    await tester.pumpAndSettle();
    var submitButtonFinder = find.byKey(const ValueKey("submit_answer_button"));
    expect(submitButtonFinder, findsOneWidget);
    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();
    await tester.pump();
    final popUpDialog = find.byKey(const ValueKey('custom_dialog'));
    expect(popUpDialog, findsOneWidget);
    final popUpText = find.descendant(
        of: popUpDialog,
        matching: find.textContaining("You can move on to the next question"));
    expect(popUpText, findsOneWidget);
    var okButton = find.text("OK");
    expect(okButton, findsOneWidget);
    // First question has been handled

    // Let's make the sharedPreferences so that the new lowest value will be some other topic:
    // We can just add 2 more correct answers to topicId 3 ('games')
    SharedPrefHelper.incrementValue(3);
    SharedPrefHelper.incrementValue(3);

    // close dialog
    await tester.tap(okButton);
    await tester.pumpAndSettle();
    var nextQuestionButton = find.byKey(const ValueKey("next_question_button"));

    // fetch new question
    await tester.tap(nextQuestionButton);
    await tester.pumpAndSettle();

    // Now we should be back on the generic_practice_page, this time with a question from another category:
    expect(questionColumn, findsOneWidget);
    final movieQuestionText = find.descendant(
        of: questionColumn, matching: find.textContaining("Movie Mania"));
    expect(movieQuestionText, findsOneWidget);
    var sharedPrefConfirm =
        interceptor.body.map((topic) => [topic['id'], topic['name']]).toList();

    // Let's check that the topic with the lowest answer count in sharedPreferences is also on the screen:
    int minval = SharedPrefHelper.getValue(sharedPrefConfirm[0][0]);
    var topicWithMinVal = sharedPrefConfirm[0][0];
    for (var item in sharedPrefConfirm) {
      var temp = SharedPrefHelper.getValue(item[0]);
      if (temp < minval) {
        topicWithMinVal = item;
        minval = temp;
      }
    }
    expect(topicWithMinVal, [2, 'movies']);
  });
}
