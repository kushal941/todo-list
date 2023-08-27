import 'package:freezed_annotation/freezed_annotation.dart';

// Note: These below imports are code generated so if missing run generator.
part 'auth_steps_model.freezed.dart';
part 'auth_steps_model.g.dart';

/// An enum representing the steps involved in auth screen.
enum AuthStep {
  /// The step for logging in to an account.
  signInStep,

  /// The step for creating a new account.
  signUpStep,
}

/// A class representing the auth steps model.
@freezed
class AuthStepsModel with _$AuthStepsModel {
  /// Private empty constructor required for getters and setters to work.
  const AuthStepsModel._();

  /// Default constructor for the [AuthStepsModel].
  const factory AuthStepsModel({
    /// The list of current auth steps.
    @Default(<AuthStep>[]) List<AuthStep> authSteps,
  }) = _AuthStepsModel;

  /// Creates an [AuthStepsModel] instance from a JSON [Map].
  factory AuthStepsModel.fromJson(Map<String, Object?> json) =>
      _$AuthStepsModelFromJson(json);

  /// Static method to get updated auth step model with the next step
  /// added to the current process.
  ///
  /// The [authStepsModel] parameter represents the current state of the auth
  /// steps model.
  /// The [nextAuthStep] parameter represents the new step to be added
  /// to the auth steps model.
  static AuthStepsModel authStepsModelWithNextStep(
    AuthStepsModel authStepsModel,
    AuthStep nextAuthStep,
  ) {
    return authStepsModel.copyWith(
      authSteps: <AuthStep>[
        ...authStepsModel.authSteps,
        nextAuthStep,
      ],
    );
  }

  /// Static method to get updated auth steps model with the last step
  /// deleted from the current auth steps model.
  ///
  /// The [authStepsModel] parameter represents the current state
  /// of the auth steps model.
  static AuthStepsModel authStepsModelWithoutLastStep(
    AuthStepsModel authStepsModel,
  ) {
    return authStepsModel.copyWith(
      authSteps: authStepsModel.authSteps.sublist(
        0,
        authStepsModel.authSteps.length - 1,
      ),
    );
  }
}
