import 'package:flutter/material.dart';
import 'package:quiz_application/pages/question_display.dart';
import '../pages/main_page.dart';
import 'package:go_router/go_router.dart';
import '../pages/statistics_page.dart';
import 'helpers/shared_pref_helper.dart';
import 'pages/generic_practice_displayer.dart';

// Set all the routes here
final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainPage()),
    GoRoute(
      path: '/topics/:topicId',
      builder: (context, state) =>
          QuestionDisplay(int.parse(state.pathParameters['topicId']!)),
    ),
    GoRoute(
      path: '/statistics',
      builder: (context, state) => const StatisticsPage(),
    ),
    GoRoute(
      path: '/generic',
      builder: (context, state) => GenericPracticeDisplayer(),
    )
  ],
);
Future main() async {
  //since main is async we need to ensure that all the widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  //initialize shared preferences
  await SharedPrefHelper.init();

  runApp(MaterialApp.router(
      // handle navigation with go_router
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        radioTheme: RadioThemeData(
          // Set the colors for radio buttons
          fillColor: MaterialStateColor.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.blue;
              }
              return Colors.black;
            },
          ),
        ),
      ),
      routerConfig: router));
}
