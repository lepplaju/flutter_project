import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_application/pages/main_page.dart';
import 'package:nock/nock.dart';
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

  // Test that the buttons are generated based on the topics that the api returns
  testWidgets('All topics that the api returns are made as buttons',
      (tester) async {
    final interceptor = nock.get('/topics')
      ..reply(
        200,
        [
          {"id": 1, "name": "Testing", "question_path": "/topics/1/questions"},
          {
            "id": 2,
            "name": "Programming",
            "question_path": "/topics/2/questions"
          },
          {
            "id": 3,
            "name": "Lorem Ipsum",
            "question_path": "/topics/3/questions"
          },
          {
            "id": 4,
            "name": "Miscellaneous",
            "question_path": "/topics/4/questions"
          }
        ],
      );

    const myApp = ProviderScope(child: MaterialApp(home: MainPage()));
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    // Pump another time to build the TopicsDisplayer widget
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
    var content = interceptor.body;
    List<dynamic> names =
        content.map((topic) => topic['name'] as String).toList();

    // Six buttons overall (statistics button at the appbar and generic practice button under other topics)
    expect(childWidgets.length, 6);
    int topicButtonCount = 0;

    for (ElevatedButton button in buttons) {
      Widget? childWidget = button.child;

      if (childWidget is SizedBox) {
        Widget? childWidget2 = childWidget.child;
        if (childWidget2 is Center) {
          Widget? childWidget3 = childWidget2.child as Text;
          if (childWidget3 is Text) {
            if (names.contains(childWidget3.data)) {
              topicButtonCount += 1;
            }
          }
        }
      }
    }

    expect(topicButtonCount, 4);
  });

// Test that the main screen will show a text "no topics found" if there are no topics
  testWidgets('Main page shows text "no topics found" when api returns nothing',
      (tester) async {
    // ignore: unused_local_variable
    final interceptor = nock.get('/topics')..reply(200, []);
    const myApp = ProviderScope(child: MaterialApp(home: MainPage()));
    await tester.pumpWidget(myApp);
    await tester.pump();
    final Finder buttonFinder = find.byType(ElevatedButton);
    final List<ElevatedButton> buttons = tester
        .widgetList(buttonFinder)
        .map((widget) => widget as ElevatedButton)
        .toList();
    expect(buttons.length, 1);
    final Finder textFinder = find.text('No topics found.');
    expect(textFinder, findsOneWidget);
  });
}
