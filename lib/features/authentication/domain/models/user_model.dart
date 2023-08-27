import 'package:freezed_annotation/freezed_annotation.dart';

// Note: These below imports are code generated so if missing run generator.
part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// A class representing the user model.
@freezed
class UserModel with _$UserModel {
  /// Private empty constructor required for getters and setters to work.
  const UserModel._();

  /// Default constructor for the [UserModel].
  const factory UserModel({
    /// The user's unique identifier.
    @Default('') String uuid,

    /// The user's display name.
    @Default('') String displayName,

    /// The user's display name.
    @Default('') String email,

    /// The user's display name.
    @Default('') String photoURL,
  }) = _UserModel;

  /// Creates an [UserModel] instance from a JSON [Map].
  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}
