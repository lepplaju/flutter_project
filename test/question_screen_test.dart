import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:quiz_application/helpers/shared_pref_helper.dart';
import 'package:quiz_application/pages/question_display.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final String _baseUrl = 'https://dad-quiz-api.deno.dev';
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });

  // Testing that the question text and the answer options from the API are shown
  testWidgets("Question text and the answer options from the API are shown",
      (tester) async {
    // We need to mock the getTopics API call
    final interceptor2 = nock('https://dad-quiz-api.deno.dev').get('/topics')
      ..reply(
        200,
        [
          {
            "id": 1,
            "name": "TestingMock",
            "question_path": "/topics/1/questions"
          },
          {
            "id": 2,
            "name": "Programming",
            "question_path": "/topics/2/questions"
          }
        ],
      );
// Then we can mock the second API call that gets the questions
    final interceptor =
        nock('https://dad-quiz-api.deno.dev').get('/topics/1/questions')
          ..reply(
            200,
            {
              "id": 3,
              "question": "this is just a test",
              "options": ["what", "is", "the", "answer"],
              "answer_post_path": "/topics/1/questions/3/answers"
            },
          );
    final myApp = MaterialApp(home: QuestionDisplay(1));
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    final questionWidget = find.byKey(ValueKey('question_text'));
    final textWidget = tester.widget<Text>(questionWidget);
    expect(textWidget.data, 'this is just a test');
    expect(questionWidget, findsOneWidget);

    // Find all the buttons
    final Finder buttonFinder = find.byType(ElevatedButton);
    final List<ElevatedButton> buttons = tester
        .widgetList(buttonFinder)
        .map((widget) => widget as ElevatedButton)
        .toList();
    List<Widget> childWidgets = [];
    for (ElevatedButton button in buttons) {
      Widget? childWidget = button.child;

      if (childWidget != null) {
        childWidgets.add(childWidget);
      }
    }
    // There should be two buttons on the screen: in the topBar and the submit button
    expect(childWidgets.length, 2);

    // Find all the radioTiles/radioButtons
    final buttonParent = find.byKey(ValueKey('button_list'));
    expect(buttonParent, findsOneWidget);
    final radioTileFinder = find.descendant(
        of: buttonParent, matching: find.byType(RadioListTile<int>));
    final List<RadioListTile> radioTiles = tester
        .widgetList(radioTileFinder)
        .map((widget) => widget as RadioListTile)
        .toList();
    var options = interceptor.body['options'];
    expect(radioTiles.length, options.length);
  });

  // Answering gives a dialog feedback (testing both correct and incorrect answers)
  testWidgets("Answering gives feedback (both correct and incorrect answers)",
      (tester) async {
    // Override get topics API call
    final topic_interceptor =
        nock('https://dad-quiz-api.deno.dev').get('/topics')
          ..reply(
            200,
            [
              {
                "id": 1,
                "name": "TestingMock",
                "question_path": "/topics/1/questions"
              },
              {
                "id": 2,
                "name": "Programming",
                "question_path": "/topics/2/questions"
              }
            ],
          );

    // Override get questions API call
    final question_interceptor =
        nock('https://dad-quiz-api.deno.dev').get('/topics/1/questions')
          ..reply(
            200,
            {
              "id": 3,
              "question": "this is just a test",
              "options": ["what", "is", "the", "answer"],
              "answer_post_path": "/topics/1/questions/3/answers"
            },
          );
    // Override wrong answer API call
    final answer_interceptor = nock('https://dad-quiz-api.deno.dev')
        .post('/topics/1/questions/3/answers', {'answer': 'what'})
      ..reply(
        200,
        {
          "correct": false,
        },
      )
      ..onReply(() {
        print('Closed the interceptor');
      });

    // Override correct answer API call
    final answer_interceptor2 = nock('https://dad-quiz-api.deno.dev')
        .post('/topics/1/questions/3/answers', {'answer': 'answer'})
      ..reply(
        200,
        {
          "correct": true,
        },
      )
      ..onReply(() {
        print('Closed the interceptor');
      });

    // Initialize sharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Initialize the sharedPrefHelper which is normally only called in main (makes the getTopics API call)
    await SharedPrefHelper.init();
    final myApp = MaterialApp(home: QuestionDisplay(1));
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();

    // First we answer a question incorrectly:
    var options = question_interceptor.body['options'];
    print(options);
    var submitButton = find.byKey(ValueKey('submit_button'));
    final buttonParent = find.byKey(ValueKey('button_list'));
    final answerRadioTile =
        find.descendant(of: buttonParent, matching: find.text(options[0]));
    expect(answerRadioTile, findsOneWidget);
    expect(submitButton, findsOneWidget);
    await tester.tap(answerRadioTile);
    await tester.pumpAndSettle();
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
    final popUpDialog = find.byKey(ValueKey('custom_dialog'));
    expect(popUpDialog, findsOneWidget);

    // Check that the popup-dialog text is what it should be:
    final popUpText = find.text('Wrong!');
    expect(popUpText, findsOneWidget);

    // -------------------------

    // Next we test that a correct answer gives appropriate popup-dialog:
    final dialogButton = find.text("OK");
    expect(dialogButton, findsOneWidget);
    await tester.tap(dialogButton);
    await tester.pumpAndSettle();
    final correctAnswerRadioTile =
        find.descendant(of: buttonParent, matching: find.text(options[3]));
    expect(correctAnswerRadioTile, findsOneWidget);
    await tester.tap(correctAnswerRadioTile);
    await tester.pumpAndSettle();
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
    final popUpDialog2 = find.byKey(ValueKey('custom_dialog'));
    expect(popUpDialog2, findsOneWidget);
    final popUpText2 = find.text('Correct!');
    expect(popUpText2, findsOneWidget);

    // make sure that there is no submit button after closing dialog:
    final dialogButton2 = find.text("OK");
    await tester.tap(dialogButton2);
    await tester.pumpAndSettle();
    expect(submitButton, findsNothing);
  });
}
