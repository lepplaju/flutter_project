import 'package:flutter/material.dart';
import '../pages/main_page.dart';
import 'package:go_router/go_router.dart';
import '../pages/question_page.dart';
import '../pages/statistics_page.dart';

// Set all the routes here
final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => MainPage()),
    GoRoute(
      path: '/topics/:topicId',
      builder: (context, state) =>
          QuestionPage(int.parse(state.pathParameters['topicId']!)),
    ),
    GoRoute(
      path: '/statistics',
      builder: (context, state) => StatisticsPage(),
    )
  ],
);
void main() {
  //debugShowCheckedModeBanner: false,
  runApp(MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        radioTheme: RadioThemeData(
          fillColor: MaterialStateColor.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return Colors
                    .blue; // Set the color for the selected radio button
              }
              return Colors
                  .black; // Set the color for the unselected radio buttons
            },
          ),
        ),
      ),
      routerConfig: router));
}
