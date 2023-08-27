import 'package:todo/features/authentication/application/services/auth_service.dart';
import 'package:todo/features/authentication/domain/models/account_model.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:todo/utils/logger_util.dart';

/// A command class responsible for signing up user with email and password.
class AuthSignUpWithEmailPasswordCommand {
  /// Creates an instance of [AuthSignUpWithEmailPasswordCommand].
  AuthSignUpWithEmailPasswordCommand(
    this._authService,
  );

  /// The auth service.
  final AuthService _authService;

  /// Runs the command.
  Future<void> run(CredentialsModel credentialsModel) async {
    try {
      await _authService.signUpWithEmailAndPassword(
        credentialsModel,
      );
    } catch (e) {
      logger.e(e);
      showErrorSnackBar(
        text: "Encountered error while signing up with email and password",
        subText: e.toString(),
      );
    }
  }
}
