import 'dart:convert';
import '../models/todo.dart';
import 'package.http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000";

  static Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse("$baseUrl/todos"));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Todo.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load todos");
    }
  }

  static Future<void> createTodo(
    String title,
    String? description,
    String? deadline,
    int priority,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/todos"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "deadline": deadline,
        "priority": priority,
        "status": 0,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create todo. Status code: ${response.statusCode}");
    }
  }

  static Future<void> updateTodo(
    int id,
    String title,
    String? description,
    int status,
    String? deadline,
    int priority,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/todos/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "status": status,
        "deadline": deadline,
        "priority": priority,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update todo");
    }
  }

  static Future<void> deleteTodo(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/todos/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete todo");
    }
  }
}