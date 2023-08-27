import 'package:todo/features/todo_management/data/repositories/todo_repository.dart';
import 'package:todo/features/todo_management/domain/models/todo_model.dart';

/// A service class responsible for managing the todos.
class TodoService {
  /// Creates an instance of [TodoService].
  TodoService(this._todoRepository);

  final TodoRepository _todoRepository;

  /// Get all todos.
  Future<List<TodoModel>> getTodos() async {
    return _todoRepository.getTodos();
  }

  /// Add todos.
  Future<void> addTodo(TodoModel todo) async {
    return _todoRepository.addTodo(todo);
  }

  /// Update todos.
  Future<void> updateTodo(TodoModel todo) async {
    return _todoRepository.updateTodo(todo);
  }

  /// Delete todos.
  Future<void> deleteTodo(String uuid) async {
    return _todoRepository.deleteTodo(uuid);
  }
}
