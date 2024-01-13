import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_application/helpers/topic.dart';
import 'package:quiz_application/helpers/topics_api.dart';
import 'package:quiz_application/widgets/top_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  // Get each topic and the corresponding number of questions answered correctly related to each topic
  Future<Map<String, int>?> loadCounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Topic> topics = await TopicsApi().getTopics();
    Map<String, int> counts = {};
    for (Topic topic in topics) {
      counts[topic.name] = prefs.getInt(topic.name) ?? 0;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>?>(
        future: loadCounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, int> savedCountList = snapshot.data!;
            var entries = savedCountList.entries.toList()
              ..sort(
                (a, b) => b.value.compareTo(a.value),
              );
            List<Widget> counterWidgets = entries.map((count) {
              return Padding(
                  padding: const EdgeInsets.all(15), // Adjusting padding
                  child: Text(
                    "${count.key}: ${count.value}",
                    style: const TextStyle(fontSize: 18),
                  ));
            }).toList();

            return ProviderScope(
                child: Scaffold(
                    appBar: TopBar(),
                    body: Center(
                        child: Container(
                            margin: const EdgeInsets.all(20),
                            child: Column(children: [
                              counterWidgets.isEmpty
                                  ? Text("No topics found.")
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                          Text("Correct answer counters:"),
                                          ...counterWidgets
                                        ]),
                              ElevatedButton(
                                  onPressed: () => context.go('/'),
                                  child: const Text('go back home'))
                            ])))));
          }
        });
  }
}
