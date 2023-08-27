import 'package:todo/features/authentication/domain/models/auth_steps_model.dart';

/// A command class responsible for navigating back during the auth steps.
///
/// This command updates the auth steps by removing the last step.
class AuthStepBackCommand {
  /// Creates an instance of [AuthStepBackCommand].
  AuthStepBackCommand(
    this.authStepsModel,
    this.updateAuthStepsModel,
  );

  /// The auth steps model.
  final AuthStepsModel authStepsModel;

  /// Callback function to update the auth steps model.
  final void Function(AuthStepsModel) updateAuthStepsModel;

  /// Runs the command.
  Future<void> run() async {
    // Update the auth steps by removing the last step based on the
    // current state.
    AuthStepsModel updatedModel =
        AuthStepsModel.authStepsModelWithoutLastStep(authStepsModel);

    updateAuthStepsModel.call(updatedModel);
  }
}

/// A command class responsible for navigating to the next auth step.
///
/// This command updates the auth steps by adding the next step.
class AuthNewStepCommand {
  /// Creates an instance of [AuthNewStepCommand].
  AuthNewStepCommand(
    this.authStepsModel,
    this.updateAuthStepsModel,
  );

  /// The auth steps model.
  final AuthStepsModel authStepsModel;

  /// Callback function to update the auth steps model.
  final void Function(AuthStepsModel) updateAuthStepsModel;

  /// Runs the command.
  Future<void> run(AuthStep nextAuthStep) async {
    // Update the auth steps by adding the next step based on the current state.

    AuthStepsModel updatedModel =
        AuthStepsModel.authStepsModelWithNextStep(authStepsModel, nextAuthStep);

    updateAuthStepsModel.call(updatedModel);
  }
}
