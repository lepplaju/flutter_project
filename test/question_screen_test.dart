import 'dart:convert';

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
// 'https://dad-quiz-api.deno.dev/topics/$topicId/questions'
// Then we can mock the second API call
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
    print(interceptor.body);
    final myApp = MaterialApp(home: QuestionDisplay(1));
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    //await tester.pump();
    //await Future.delayed(Duration(seconds: 5));
    //final questionWidget = find.text('this is just a test');
    final questionWidget = find.byKey(ValueKey('question_text'));
    final textWidget = tester.widget<Text>(questionWidget);
    //print(textWidget.data);
    expect(textWidget.data, 'this is just a test');
    expect(questionWidget, findsOneWidget);
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
    // There are two buttons on the screen: in the topBar and the submit button
    expect(childWidgets.length, 2);

    // Find all the radioTiles
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

  // Answering gives feedback (both correct and incorrect answers)
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
    // Override submit answer API call
    final answer_interceptor = nock('https://dad-quiz-api.deno.dev')
        .post('/topics/1/questions/3/answers', {'answer': 'what'})
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
    // await tester.pump();
    var options = question_interceptor.body['options'];
    print(options);
    var submitButton = find.byKey(ValueKey('submit_button'));
    final buttonParent = find.byKey(ValueKey('button_list'));
    final answerRadioTile =
        find.descendant(of: buttonParent, matching: find.text(options[0]));
    print(answerRadioTile);
    expect(answerRadioTile, findsOneWidget);
    expect(submitButton, findsOneWidget);
    await tester.tap(answerRadioTile);
    await tester.pumpAndSettle();
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
    await tester.pump();
    final popUpDialog = find.byKey(ValueKey('custom_dialog'));
    expect(popUpDialog, findsOneWidget);
  });
}
