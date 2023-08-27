import 'package:todo/features/todo_management/domain/models/todo_model.dart';

/// Interface for todos repository
abstract class TodoRepository {
  /// Get all todos.
  Future<List<TodoModel>> getTodos();

  /// Add todos.
  Future<void> addTodo(TodoModel todo);

  /// Update todos.
  Future<void> updateTodo(TodoModel todo);

  /// Delete todos.
  Future<void> deleteTodo(String uuid);
}
