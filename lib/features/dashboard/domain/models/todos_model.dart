import 'package:todo/features/todo_management/domain/models/todo_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Note: These below imports are code generated so if missing run generator.
part 'todos_model.freezed.dart';
part 'todos_model.g.dart';

/// A class representing the todos models.
@freezed
class TodosModel with _$TodosModel {
  /// Private empty constructor required for getters and setters to work.
  const TodosModel._();

  /// Default constructor for the [TodosModel].
  const factory TodosModel({
    /// The list of todos.
    @Default(<TodoModel>[]) List<TodoModel> todos,
  }) = _TodosModel;

  /// Creates an [TodosModel] instance from a JSON [Map].
  factory TodosModel.fromJson(Map<String, Object?> json) =>
      _$TodosModelFromJson(json);
}
