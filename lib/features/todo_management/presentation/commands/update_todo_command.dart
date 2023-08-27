import 'package:todo/features/dashboard/domain/models/todos_model.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/info_snackbar.dart';
import 'package:todo/features/todo_management/application/services/todo_service.dart';
import 'package:todo/features/todo_management/domain/models/todo_model.dart';
import 'package:todo/utils/logger_util.dart';

/// A command class responsible for updating todos.
///
/// This command updates the todos model with the updated todos.
class UpdateTodoCommand {
  /// Creates an instance of [UpdateTodoCommand].
  UpdateTodoCommand(
    this._todoService,
    this.updateTodosModel,
  );

  /// The auth service.
  final TodoService _todoService;

  /// Callback function to update the user model.
  final void Function(TodosModel) updateTodosModel;

  /// Runs the command.
  Future<void> run(TodoModel todo, TodosModel todosModel) async {
    showInfoSnackBar(text: 'Updating todo...');

    // Update the todos model with the updated todos.
    TodosModel updatedModel = todosModel.copyWith(
      //use the todos uuid to find the todos in the list and update it
      todos: todosModel.todos.map((TodoModel element) {
        if (element.uuid == todo.uuid) {
          return todo;
        } else {
          return element;
        }
      }).toList(),
    );

    updateTodosModel.call(updatedModel);

    try {
      await _todoService.updateTodo(todo);

      showInfoSnackBar(text: 'Todo updated');
    } catch (e) {
      logger.e(e);
      updateTodosModel.call(todosModel);

      showErrorSnackBar(text: 'Failed to update todo', subText: e.toString());
    }
  }
}
