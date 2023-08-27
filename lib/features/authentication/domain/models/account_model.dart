import 'package:freezed_annotation/freezed_annotation.dart';
// Note: These below imports are code generated so if missing run generator.
part 'account_model.freezed.dart';
part 'account_model.g.dart';

/// A class representing the user sign in and sign up credentials model.
@freezed
class CredentialsModel with _$CredentialsModel {
  /// Private empty constructor required for getters and setters to work.
  const CredentialsModel._();

  /// Default constructor for the [CredentialsModel].
  const factory CredentialsModel({
    /// The user's display email.
    required String email,

    /// The user's display password.
    required String password,
  }) = _CredentialsModel;

  /// Creates an [CredentialsModel] instance from a JSON [Map].
  factory CredentialsModel.fromJson(Map<String, Object?> json) =>
      _$CredentialsModelFromJson(json);
}
