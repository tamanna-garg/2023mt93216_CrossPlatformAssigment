import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/back4app_config.dart';
import '../models/task_model.dart';
import 'auth_service.dart';

class TaskService {
  static Future<List<TaskModel>> fetchTasks() async {
    final userId = AuthService.currentUserId;
    if (userId == null) throw Exception('User not logged in');

    final response = await http.get(
      Uri.parse(
          '${Back4AppConfig.serverUrl}/classes/Task?where={"user":{"__type":"Pointer","className":"_User","objectId":"$userId"}}'),
      headers: {
        'X-Parse-Application-Id': Back4AppConfig.appId,
        'X-Parse-Client-Key': Back4AppConfig.clientKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['results'] as List;
      return data.map((task) => TaskModel.fromJson(task)).toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  static Future<void> addTask(TaskModel task) async {
    final userId = AuthService.currentUserId;
    if (userId == null) throw Exception('User not logged in');

    final response = await http.post(
      Uri.parse('${Back4AppConfig.serverUrl}/classes/Task'),
      headers: {
        'X-Parse-Application-Id': Back4AppConfig.appId,
        'X-Parse-Client-Key': Back4AppConfig.clientKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        ...task.toJson(),
        'user': {
          '__type': 'Pointer',
          'className': '_User',
          'objectId': userId,
        },
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add task');
    }
  }

  static Future<void> deleteTask(String taskId) async {
    final response = await http.delete(
      Uri.parse('${Back4AppConfig.serverUrl}/classes/Task/$taskId'),
      headers: {
        'X-Parse-Application-Id': Back4AppConfig.appId,
        'X-Parse-Client-Key': Back4AppConfig.clientKey,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  static Future<void> toggleTaskStatus(String taskId, bool isCompleted) async {
    final response = await http.put(
      Uri.parse('${Back4AppConfig.serverUrl}/classes/Task/$taskId'),
      headers: {
        'X-Parse-Application-Id': Back4AppConfig.appId,
        'X-Parse-Client-Key': Back4AppConfig.clientKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'isCompleted': isCompleted}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task status');
    }
  }
}
