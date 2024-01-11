import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  Future<int?> loadCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('count') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
        future: loadCount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            int? savedcount = snapshot.data ?? 0;
            return ProviderScope(
                child: Scaffold(
                    body: Center(
                        child: Container(
                            margin: const EdgeInsets.all(20),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      "Count of correctly answered questions: $savedcount"),
                                  ElevatedButton(
                                      onPressed: () => context.go('/'),
                                      child: const Text('go back home'))
                                ])))));
          }
        });
  }
}
