import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:quiz_application/helpers/shared_pref_helper.dart';
import 'package:quiz_application/pages/generic_practice_displayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });
  testWidgets(
      "Generic practice shows question from topic with fewest correct answers",
      (tester) async {
    final interceptor = nock('https://dad-quiz-api.deno.dev').get('/topics')
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
    final question_interceptor =
        nock('https://dad-quiz-api.deno.dev').get('/topics/3/questions')
          ..reply(
            200,
            {
              "id": 3,
              "question": "this question is about games",
              "options": ["wrong", "wrong", "correct", "wrong"],
              "answer_post_path": "/topics/3/questions/3/answers"
            },
          );
    SharedPreferences.setMockInitialValues({
      'fun facts': 3,
      'movies': 3,
      'games': 1,
      'Miscellaneous': 3,
      'all': 10
    });
    await SharedPrefHelper.init();

    final myApp = MaterialApp(home: GenericPracticeDisplayer());
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    // The initial generic_practice_page is just information about what is going to happen. We need to press a button to proceed to the question
    var buttonFinder = find.byKey(ValueKey("get_question_button"));
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();
    // Now we should be on the question page
    var submitButtonFinder = find.byKey(ValueKey("submit_answer_button"));
    expect(submitButtonFinder, findsOneWidget);

    var questionColumn = find.byKey(ValueKey("question_column"));
    expect(questionColumn, findsOneWidget);
    final questionText = find.descendant(
        of: questionColumn,
        matching: find.textContaining("this question is about games"));
    expect(questionText, findsOneWidget);
    //var searchText = find.text("this question is about games");
    //expect(searchText, findsOneWidget);
  });
}
