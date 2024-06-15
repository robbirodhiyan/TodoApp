import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:todos/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  final List<TodoItem> _todos = [];
  final baseUrl = 'http://192.168.100.21:5000/api/todos/';

  final Logger _logger = Logger();

  List<TodoItem> get todos {
    return [..._todos];
  }

  Future<void> createTodo(String task) async {
    if (task.isEmpty) {
      return;
    }

    Map<String, dynamic> data = {"name": task, "is_executed": false};

    final headers = {"Content-Type": "application/json"};
    final response = await http.post(Uri.parse(baseUrl),
        headers: headers, body: json.encode(data));

    if (response.statusCode == 201) {
      Map<String, dynamic> responsePayload = json.decode(response.body);
      final todo = TodoItem(
          id: responsePayload["public_id"],
          todoID: responsePayload["todo_id"],
          todoName: responsePayload["name"],
          isExecuted: responsePayload["is_executed"],
          createdAt: DateTime.parse(responsePayload['created_at']),
          updatedAt: DateTime.parse(responsePayload['updated_at']),
        );

      _todos.add(todo);
      notifyListeners();
    } else {
      throw Exception('Failed to create todo');
    }
  }

  Future<void> getTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        List<dynamic> todosList = responseBody['todos'];
        _todos.clear();
        for (var resultat in todosList) {
          final todo = TodoItem(
            id: resultat["public_id"],
            todoID: resultat["todo_id"],
            todoName: resultat["name"],
            isExecuted: resultat["is_executed"],
            createdAt: DateTime.parse(resultat['created_at']),
            updatedAt: DateTime.parse(resultat['updated_at']),
          );
          _todos.add(todo);
        }
        notifyListeners();
      } else {
        throw Exception('Failed to fetch todos');
      }
    } catch (err) {
      _logger.e('Error to load todos: $err');
    }
  }

  Future<void> readTodo(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id/'));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final todoData = responseBody['todo'];
        final todo = TodoItem(
          id: todoData['public_id'],
          todoID: todoData['todo_id'],
          todoName: todoData['name'],
          isExecuted: todoData['is_executed'],
          createdAt: DateTime.parse(todoData['created_at']),
          updatedAt: DateTime.parse(todoData['updated_at']),
        );
        _todos.add(todo);
        notifyListeners();
      } else {
        throw Exception('Failed to fetch todos');
      }
    } catch (err) {
      _logger.e('Error to load todos: $err');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id/'));
      if (response.statusCode == 204) {
        _todos.removeWhere((todo) => todo.id == id);
        notifyListeners();
        _logger.e('Todo deleted successfully !');
      } else {
        throw Exception('Failed to delete todo: ${response.statusCode}');
      }
    } catch (err) {
      _logger.e('Error deleting todo: $err');
    }
  }

  Future<void> updateTodo(String id, Map<String, dynamic> data) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode(data);

      final response = await http.patch(
        Uri.parse('$baseUrl/$id/'), headers: headers, body: body
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        _logger.i("Error to update todo: $responseBody['message']");
        notifyListeners();
      } else {
        throw Exception('Failed to update todo');
      }
    } catch (err) {
      _logger.e('Error to update todo: $err');
    }
  }
}
