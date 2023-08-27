import 'package:todo/features/dashboard/domain/models/todos_model.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/info_snackbar.dart';
import 'package:todo/features/todo_management/application/services/todo_service.dart';
import 'package:todo/utils/logger_util.dart';

/// A command class responsible for loading todos.
///
/// This command updates the todos model with the loaded todos.
class LoadTodosCommand {
  /// Creates an instance of [LoadTodosCommand].
  LoadTodosCommand(
    this._todoService,
    this.updateTodosModel,
  );

  /// The auth service.
  final TodoService _todoService;

  /// Callback function to update the user model.
  final void Function(TodosModel) updateTodosModel;

  /// Runs the command.
  Future<void> run() async {
    showInfoSnackBar(text: 'Loading todos...');

    TodosModel todosModel;

    try {
      todosModel = TodosModel(
        todos: await _todoService.getTodos(),
      );
      updateTodosModel.call(todosModel);

      showInfoSnackBar(text: 'Todos loaded');
    } catch (e) {
      logger.e(e);

      showErrorSnackBar(text: 'Failed to load todos', subText: e.toString());
    }
  }
}
