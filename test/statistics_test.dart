import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:quiz_application/pages/statistics_page.dart';
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
  testWidgets("Total correct count matches with sharedpreferences",
      (tester) async {
    // ignore: unused_local_variable
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

    const myApp = MaterialApp(home: StatisticsPage());
    SharedPreferences.setMockInitialValues({
      'fun facts': 1,
      'movies': 2,
      'games': 1,
      'Miscellaneous': 1,
      'all': 5
    });

    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    final SharedPreferences testPrefs = await SharedPreferences.getInstance();
    var totalCount = testPrefs.getInt('all');
    await tester.pump();

    // Making sure that the total count is the same on screen as on the shared preferences
    var allText = find.text('all:');
    var allCountWidget = find.byKey(const ValueKey('topic_value_all'));
    var allCountText = tester.widget<Text>(allCountWidget).data;
    expect(allCountText, '5');
    expect(allText, findsOneWidget);
    expect(totalCount, 5);
  });

  testWidgets(
      "Statistics page shows correct amount of answered questions for each topic",
      (tester) async {
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

    // Setting the shared preferences to have some values
    SharedPreferences.setMockInitialValues({
      'fun facts': 1,
      'movies': 2,
      'games': 3,
      'Miscellaneous': 4,
      'all': 10
    });

    const myApp = MaterialApp(home: StatisticsPage());
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    await tester.pump();
    var statsContainer = find.byKey(const ValueKey('stats_column'));
    expect(statsContainer, findsOneWidget);
    final statsColumn =
        find.descendant(of: statsContainer, matching: find.byType(Column));
    expect(statsColumn, findsOneWidget);
    final statsRows =
        find.descendant(of: statsColumn, matching: find.byType(Row));
    final statsRowsList = tester.widgetList(statsRows);
    expect(statsRowsList.length, 5);

    var idsAndKeys =
        interceptor.body.map((topic) => [topic['id'], topic['name']]).toList();
    dynamic keyId;
    int count = 0;

    // Here we find all the text fields that display the number of correctly answered questions for each topic
    for (var rowItem in statsRowsList) {
      Row rowWidget = rowItem as Row;
      List<Expanded> expandedWidgets =
          rowWidget.children.whereType<Expanded>().toList();
      List<Text> textWidgets = [];
      for (var expanded in expandedWidgets) {
        Text textWidget = expanded.child as Text;
        textWidgets.add(textWidget);
      }
      var keyAndValue =
          textWidgets.map((text) => text.data!.replaceAll(':', '')).toList();

      keyId = idsAndKeys.firstWhere(
          (item) => (item as List<dynamic>)[1] == keyAndValue[0],
          orElse: () => null);
      if (keyId != null) {
        // only go here if we match text from sharedPref and the screen
        count++;
        // Here we check that each displayed count is the same as in SharedPreferences
        expect(keyId[0], int.parse(keyAndValue[1].trim()));
        // Here we check that the numbers in SharedPreferences and the screen are the same.
      }
    }
    expect(count, 4);
  });
}
