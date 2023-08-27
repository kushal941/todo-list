import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/features/authentication/presentation/states/auth_state.dart';
import 'package:todo/features/dashboard/domain/models/todos_model.dart';
import 'package:todo/features/dashboard/presentation/commands/delete_todo_command.dart';
import 'package:todo/features/dashboard/presentation/commands/load_todos_command.dart';
import 'package:todo/features/todo_management/application/services/todo_service.dart';
import 'package:todo/features/todo_management/data/repositories/firebase_todo_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Note: These below imports are code generated so if missing run generator.
part 'todos_state.g.dart';

/// A class representing the state of the [TodosModel] model.
@riverpod
class TodosModelState extends _$TodosModelState {
  @override
  TodosModel build() {
    return const TodosModel();
  }
}

/// A class representing the state of the [LoadTodosCommand] command.
@riverpod
class LoadTodosCommandState extends _$LoadTodosCommandState {
  @override
  LoadTodosCommand build() {
    return LoadTodosCommand(
      ref.watch(todoServiceStateProvider),
      (TodosModel todosModel) {
        ref.read(todosModelStateProvider.notifier).state = todosModel;
      },
    );
  }
}

/// A class representing the state of the [DeleteTodoCommand] command.
@riverpod
class DeleteTodoCommandState extends _$DeleteTodoCommandState {
  @override
  DeleteTodoCommand build() {
    return DeleteTodoCommand(
      ref.watch(todoServiceStateProvider),
      (TodosModel todosModel) {
        ref.read(todosModelStateProvider.notifier).state = todosModel;
      },
    );
  }
}

/// A class representing the state of the [TodoService] service.
@riverpod
class TodoServiceState extends _$TodoServiceState {
  @override
  TodoService build() {
    return TodoService(
      FirebaseTodoImpl(
        ref.watch(firebaseAuthStateProvider),
        ref.watch(firestoreStateProvider),
      ),
    );
  }
}

/// A class representing the state of the [FirebaseFirestore] service.
@Riverpod(keepAlive: true)
class FirestoreState extends _$FirestoreState {
  @override
  FirebaseFirestore build() {
    return FirebaseFirestore.instance;
  }
}
