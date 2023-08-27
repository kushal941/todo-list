import 'package:todo/features/dashboard/domain/models/todos_model.dart';
import 'package:todo/features/todo_management/presentation/commands/add_todo_command.dart';
import 'package:todo/features/todo_management/presentation/commands/update_todo_command.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo/features/dashboard/presentation/states/todos_state.dart';

// Note: These below imports are code generated so if missing run generator.
part 'todo_state.g.dart';

/// A class representing the state of the [AddTodoCommand] command.
@riverpod
class AddTodoCommandCommandState extends _$AddTodoCommandCommandState {
  @override
  AddTodoCommand build() {
    return AddTodoCommand(
      ref.watch(todoServiceStateProvider),
      (TodosModel todosModel) {
        ref.read(todosModelStateProvider.notifier).state = todosModel;
      },
    );
  }
}

/// A class representing the state of the [UpdateTodoCommand] command.
@riverpod
class UpdateTodoCommandState extends _$UpdateTodoCommandState {
  @override
  UpdateTodoCommand build() {
    return UpdateTodoCommand(
      ref.watch(todoServiceStateProvider),
      (TodosModel todosModel) {
        ref.read(todosModelStateProvider.notifier).state = todosModel;
      },
    );
  }
}
