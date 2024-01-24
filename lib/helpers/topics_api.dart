import 'dart:convert';
import 'package:http/http.dart' as http;
import './topic.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TopicsApi {
  Future<List<Topic>> getTopics() async {
    var response =
        await http.get(Uri.parse('${dotenv.env['API_BASE_URL']}/topics'));

    List<dynamic> topicItems = jsonDecode(response.body);
    return List<Topic>.from(
        topicItems.map((jsonData) => Topic.fromJson(jsonData)));
  }
}
