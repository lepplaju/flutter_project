import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '/helpers/topics_api.dart';

class TopicNotifier extends StateNotifier<List<String>> {
  final topicApi = TopicsApi();
  TopicNotifier() : super([]);
  _initialize() async {
    state = await topicApi.getTopics();
  }
}

final topicProvider = StateNotifierProvider<TopicNotifier, List<String>>((ref) {
  final tn = TopicNotifier();
  tn._initialize();
  return tn;
});
