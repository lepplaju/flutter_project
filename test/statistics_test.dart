import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:quiz_application/helpers/shared_pref_helper.dart';
import 'package:quiz_application/pages/statistics_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });
  testWidgets("Statistics page shows correct amount of answered questions",
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

/*
    List<dynamic> names =
        interceptor.body.map((topic) => topic['name'] as String).toList();
    print(names);
    Map<String, dynamic> sharedPrefMockVals = {};
    for (int i = 0; i < names.length; i++) {
      sharedPrefMockVals['${names[i]}'] = 1 + i;
    }
    */
    // Setting the shared preferences to have some values
    SharedPreferences.setMockInitialValues({
      'fun facts': 1,
      'movies': 2,
      'games': 3,
      'Miscellaneous': 4,
    });

    final myApp = MaterialApp(home: StatisticsPage());
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    await tester.pump();
    var statsContainer = find.byKey(ValueKey('stats_column'));
    expect(statsContainer, findsOneWidget);
    final statsColumn =
        find.descendant(of: statsContainer, matching: find.byType(Column));
    expect(statsColumn, findsOneWidget);
    final statsTexts =
        find.descendant(of: statsColumn, matching: find.byType(Text));
    //print(statsTexts);
    final statsTextsList = tester.widgetList(statsTexts);
    //print(statsTextsList);

    var idsAndKeys =
        interceptor.body.map((topic) => [topic['id'], topic['name']]).toList();
    //print(idsAndKeys[0]);
    var keyId;
    int count = 0;
    print('list starts here');
    for (var mytextWidget in statsTextsList) {
      Text textWidget = mytextWidget as Text;
      var keyAndValue = textWidget.data!.split(':');
      keyId = idsAndKeys.firstWhere(
          (item) => (item as List<dynamic>)[1] == keyAndValue[0],
          orElse: () => null);
      if (keyId != null) {
        // only go here if we match text from sharedPref and the screen
        count++;
        print("$keyId $keyAndValue");
        expect(keyId[0], int.parse(keyAndValue[1].trim()));
        // Here we check that the numbers in SharedPreferences and the screen are the same.
      }
    }
    expect(count, 4);
  });
}
