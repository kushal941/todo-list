import 'package:todo/features/authentication/application/services/auth_service.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:todo/utils/logger_util.dart';

/// A command class responsible for signing in user with google.
class AuthSignInWithGoogleCommand {
  /// Creates an instance of [AuthSignInWithGoogleCommand].
  AuthSignInWithGoogleCommand(
    this._authService,
  );

  /// The auth service.
  final AuthService _authService;

  /// Runs the command.
  Future<void> run() async {
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      logger.e(e);
      showErrorSnackBar(
        text: "Encountered error while signing in with google",
        subText: e.toString(),
      );
    }
  }
}
