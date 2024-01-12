import 'package:quiz_application/helpers/topic.dart';
import 'package:quiz_application/helpers/topics_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This class will help keep track of the number of questions answered correctly
class SharedPrefHelper {
  static late SharedPreferences _preferences;
  static late List<Topic> _topics;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
    _topics = await TopicsApi().getTopics();
  }

  static Future incrementValue(int topicId) async {
    Topic matchingTopic = _topics.firstWhere(
      (topic) => topic.id == topicId,
    );

    await _preferences.setInt(
        matchingTopic.name, (_preferences.getInt(matchingTopic.name) ?? 0) + 1);
  }

  static int getValue(int topicId) {
    Topic matchingTopic = _topics.firstWhere(
      (topic) => topic.id == topicId,
    );
    return _preferences.getInt(matchingTopic.name) ?? 0;
  }
}
