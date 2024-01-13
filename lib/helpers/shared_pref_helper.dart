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

  // Return the number of correcly answered questions for a given topic
  static int getValue(int topicId) {
    Topic matchingTopic = _topics.firstWhere(
      (topic) => topic.id == topicId,
    );
    return _preferences.getInt(matchingTopic.name) ?? 0;
  }

  // Return the topicID with the least number of questions answered correctly
  static int getMinimumValue() {
    //List<String> names = _topics.map((topic) => topic.name).toList();
    int min_value = _preferences.getInt(_topics[0].name) ?? 0;
    int id_with_min_value = _topics[0].id;
    for (Topic topic in _topics) {
      int temp = _preferences.getInt(topic.name) ?? 0;
      print("${topic.name}: ${topic.id}: $temp");
      if (temp < min_value) {
        min_value = temp;
        id_with_min_value = topic.id;
      }
    }
    return id_with_min_value;
  }
}
