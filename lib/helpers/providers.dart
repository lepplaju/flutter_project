import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/helpers/topics_api.dart';
import '/helpers/topic.dart';
import '/helpers/question.dart';
import '/helpers/questions_api.dart';

class TopicNotifier extends StateNotifier<List<Topic>> {
  final topicApi = TopicsApi();
  TopicNotifier() : super([]);

  _initialize() async {
    state = await topicApi.getTopics();
  }
}

final topicProvider = StateNotifierProvider<TopicNotifier, List<Topic>>((ref) {
  final tn = TopicNotifier();
  tn._initialize();
  return tn;
});

class QuestionNotifier extends StateNotifier<Question?> {
  final topicId;
  final questionApi = QuestionsApi();
  QuestionNotifier(this.topicId) : super(null);

  _initialize() async {
    state = await questionApi.getRandomQuestion(topicId);
  }
}
