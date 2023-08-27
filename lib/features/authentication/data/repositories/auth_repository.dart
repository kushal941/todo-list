import 'package:todo/features/authentication/domain/models/account_model.dart';
import 'package:todo/features/authentication/domain/models/user_model.dart';

/// Interface for authentication repository
abstract class AuthRepository {
  /// Check if user is logged in.
  Future<bool> isLoggedIn();

  /// Sign in user with email and password.
  Future<UserModel> signInWithEmailAndPassword(
    CredentialsModel credentialsModel,
  );

  /// Sign up user with email and password.
  Future<UserModel> signUpWithEmailAndPassword(
    CredentialsModel credentialsModel,
  );

  /// Sign in user with google.
  Future<UserModel> signInWithGoogle();

  /// Sign out user.
  Future<void> signOut();
}
