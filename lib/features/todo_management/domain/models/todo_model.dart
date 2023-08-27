import 'package:freezed_annotation/freezed_annotation.dart';

// Note: These below imports are code generated so if missing run generator.
part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

/// The type of todos.
enum TodoType {
  /// The business type of todos.
  business,

  /// The personal type of todos.
  personal,

  /// The fun type of todos.
  fun,
}

/// A class representing the todos model.
@freezed
class TodoModel with _$TodoModel {
  /// Private empty constructor required for getters and setters to work.
  const TodoModel._();

  /// Default constructor for the [TodoModel].
  const factory TodoModel({
    /// The todos unique identifier.
    required String uuid,

    /// The todos title.
    required String title,

    /// The todos description.
    required String description,

    /// The todos date time.
    required DateTime dateTime,

    /// The todos type.
    required TodoType type,

    /// The todos is completed.
    required bool isCompleted,
  }) = _TodoModel;

  /// Creates an [TodoModel] instance from a JSON [Map].
  factory TodoModel.fromJson(Map<String, Object?> json) =>
      _$TodoModelFromJson(json);
}
