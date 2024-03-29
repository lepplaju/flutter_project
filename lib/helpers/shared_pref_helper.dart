import 'package:quiz_application/helpers/topic.dart';
import 'package:quiz_application/helpers/topics_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This class will help keep track of the number of questions answered correctly
class SharedPrefHelper {
  static SharedPreferences? _preferences;
  static List<Topic>? _topics;

  static Future init() async {
    _topics = await TopicsApi().getTopics();
    _preferences = await SharedPreferences.getInstance();
  }

  static Future reset() async {
    await _preferences!.clear();
  }

  static Future incrementValue(int topicId) async {
    Topic matchingTopic = _topics!.firstWhere(
      (topic) => topic.id == topicId,
    );
    await _preferences!.setInt('all', (_preferences!.getInt('all') ?? 0) + 1);
    await _preferences!.setInt(matchingTopic.name,
        (_preferences!.getInt(matchingTopic.name) ?? 0) + 1);
  }

  // Return the number of correcly answered questions for a given topic
  static int getValue(int topicId) {
    Topic? matchingTopic = _topics!.firstWhere((topic) => topic.id == topicId);
    return _preferences!.getInt(matchingTopic.name) ?? 0;
  }

  // Return the number value from a given key directly
  static int getValueByKey(String prefKey) {
    return _preferences!.getInt(prefKey) ?? 0;
  }

  // Return the topicID with the least number of questions answered correctly
  static int getMinimumValue() {
    //List<String> names = _topics.map((topic) => topic.name).toList();
    int minValue = _preferences!.getInt(_topics![0].name) ?? 0;
    int idWithMinValue = _topics![0].id;
    for (Topic topic in _topics!) {
      int temp = _preferences!.getInt(topic.name) ?? 0;
      if (temp < minValue) {
        minValue = temp;
        idWithMinValue = topic.id;
      }
    }
    return idWithMinValue;
  }
}
