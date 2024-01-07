import 'package:flutter/material.dart';
import '../pages/main_page.dart';
import 'package:go_router/go_router.dart';
import '../pages/question_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => MainPage()),
    GoRoute(
      path: '/topics/:topicId',
      builder: (context, state) =>
          QuestionPage(int.parse(state.pathParameters['topicId']!)),
    ),
  ],
);
void main() {
  //debugShowCheckedModeBanner: false,
  runApp(MaterialApp.router(routerConfig: router));
  /*runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));*/
}
