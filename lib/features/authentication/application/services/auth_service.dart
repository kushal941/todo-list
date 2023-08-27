import 'package:todo/features/authentication/data/repositories/auth_repository.dart';
import 'package:todo/features/authentication/domain/models/account_model.dart';
import 'package:todo/features/authentication/domain/models/user_model.dart';

/// A service class responsible for managing the authentication.
class AuthService {
  /// Creates an instance of [AuthService].
  AuthService(this._authRepository);

  final AuthRepository _authRepository;

  /// Check if user is logged in.
  Future<bool> isLoggedIn() async {
    try {
      return await _authRepository.isLoggedIn();
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in user with email and password.
  Future<UserModel> signInWithEmailAndPassword(
    CredentialsModel credentialsModel,
  ) async {
    try {
      return _authRepository.signInWithEmailAndPassword(credentialsModel);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign up user with email and password.
  Future<UserModel> signUpWithEmailAndPassword(
    CredentialsModel credentialsModel,
  ) async {
    try {
      return _authRepository.signUpWithEmailAndPassword(credentialsModel);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in user with google.
  Future<UserModel> signInWithGoogle() async {
    try {
      return _authRepository.signInWithGoogle();
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out user.
  Future<void> signOut() async {
    try {
      return _authRepository.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
