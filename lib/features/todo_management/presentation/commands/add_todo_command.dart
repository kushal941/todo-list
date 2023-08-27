import 'package:todo/features/dashboard/domain/models/todos_model.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/info_snackbar.dart';
import 'package:todo/features/todo_management/application/services/todo_service.dart';
import 'package:todo/features/todo_management/domain/models/todo_model.dart';
import 'package:todo/utils/logger_util.dart';

/// A command class responsible for adding todos.
///
/// This command updates the todos model with the updated todos.
class AddTodoCommand {
  /// Creates an instance of [AddTodoCommand].
  AddTodoCommand(
    this._todoService,
    this.updateTodosModel,
  );

  /// The auth service.
  final TodoService _todoService;

  /// Callback function to update the user model.
  final void Function(TodosModel) updateTodosModel;

  /// Runs the command.
  Future<void> run(TodoModel todo, TodosModel todosModel) async {
    showInfoSnackBar(text: 'Adding todo...');

    // Update the todos model with the new todos.
    TodosModel updatedModel = todosModel.copyWith(
      todos: <TodoModel>[...todosModel.todos, todo],
    );

    updateTodosModel.call(updatedModel);

    try {
      await _todoService.addTodo(todo);

      showInfoSnackBar(text: 'Todo added');
    } catch (e) {
      logger.e(e);
      updateTodosModel.call(todosModel);

      showErrorSnackBar(text: 'Failed to add todo', subText: e.toString());
    }
  }
}
