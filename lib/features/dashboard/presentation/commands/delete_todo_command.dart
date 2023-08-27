import 'package:todo/features/dashboard/domain/models/todos_model.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/info_snackbar.dart';
import 'package:todo/features/todo_management/application/services/todo_service.dart';
import 'package:todo/features/todo_management/domain/models/todo_model.dart';
import 'package:todo/utils/logger_util.dart';

/// A command class responsible for deleting todos.
///
/// This command updates the todos model with the updated todos.
class DeleteTodoCommand {
  /// Creates an instance of [DeleteTodoCommand].
  DeleteTodoCommand(
    this._todoService,
    this.updateTodosModel,
  );

  /// The auth service.
  final TodoService _todoService;

  /// Callback function to update the user model.
  final void Function(TodosModel) updateTodosModel;

  /// Runs the command.
  Future<void> run(String uuid, TodosModel todosModel) async {
    showInfoSnackBar(text: 'Deleting todo...');

    // Update the todos model without the deleted todos.
    TodosModel updatedModel = todosModel.copyWith(
      todos: todosModel.todos
          .where((TodoModel element) => element.uuid != uuid)
          .toList(),
    );

    updateTodosModel.call(updatedModel);

    try {
      await _todoService.deleteTodo(
        uuid,
      );

      showInfoSnackBar(text: 'Todo deleted');
    } catch (e) {
      logger.e(e);
      updateTodosModel.call(todosModel);
      showErrorSnackBar(text: 'Failed to delete todo', subText: e.toString());
    }
  }
}
