import 'dart:async';

import 'package:todo/features/authentication/application/services/auth_service.dart';
import 'package:todo/features/authentication/data/repositories/firebase_auth_impl.dart';
import 'package:todo/features/authentication/domain/models/auth_steps_model.dart';
import 'package:todo/features/authentication/domain/models/user_model.dart';
import 'package:todo/features/authentication/presentation/commands/auth_sign_in_with_email_password_command.dart';
import 'package:todo/features/authentication/presentation/commands/auth_sign_out.dart';
import 'package:todo/features/authentication/presentation/commands/auth_sign_up_with_email_password_command.dart';
import 'package:todo/features/authentication/presentation/commands/auth_steps_nav_commands.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:todo/features/authentication/presentation/commands/auth_sign_in_with_google_command.dart';

// Note: These below imports are code generated so if missing run generator.
part 'auth_state.g.dart';

/// A class representing the state of the [FirebaseAuth].
@Riverpod(keepAlive: true)
class FirebaseAuthState extends _$FirebaseAuthState {
  @override
  FirebaseAuth build() {
    return FirebaseAuth.instance;
  }
}

/// A stream representing the state of the authentication.
@riverpod
class AuthState extends _$AuthState {
  @override
  Stream<bool> build() {
    FirebaseAuth firebaseAuth = ref.watch(firebaseAuthStateProvider);
    StreamController<bool> controller = StreamController<bool>();

    firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        controller.add(false);
      } else {
        controller.add(true);
      }
    });

    return controller.stream;
  }
}

/// A class representing the state of the [UserModel] model.
@riverpod
class UserModelState extends _$UserModelState {
  @override
  UserModel build() {
    FirebaseAuth firebaseAuth = ref.watch(firebaseAuthStateProvider);

    return UserModel(
      uuid: firebaseAuth.currentUser!.uid,
      email: firebaseAuth.currentUser!.email!,
      displayName: firebaseAuth.currentUser!.displayName ?? 'Anon Name',
      photoURL: firebaseAuth.currentUser!.photoURL ??
          'https://picsum.photos/seed/picsum/200/300',
    );
  }
}

/// A class representing the state of the [AuthService] service.
@riverpod
class AuthServiceState extends _$AuthServiceState {
  @override
  AuthService build() {
    return AuthService(
      FirebaseAuthImpl(ref.watch(firebaseAuthStateProvider)),
    );
  }
}

/// A class representing the state of the [AuthSignInWithGoogleCommand] command.
@riverpod
class AuthSignInWithGoogleCommandState
    extends _$AuthSignInWithGoogleCommandState {
  @override
  AuthSignInWithGoogleCommand build() {
    return AuthSignInWithGoogleCommand(
      ref.watch(authServiceStateProvider),
    );
  }
}

/// A class representing the state of the [AuthSignOutCommand] command.
@riverpod
class AuthSignOutCommandState extends _$AuthSignOutCommandState {
  @override
  AuthSignOutCommand build() {
    return AuthSignOutCommand(
      ref.watch(authServiceStateProvider),
    );
  }
}

/// A class representing the state of the [AuthSignInWithEmailPasswordCommand]
/// command.
@riverpod
class AuthSignInWithEmailPasswordCommandState
    extends _$AuthSignInWithEmailPasswordCommandState {
  @override
  AuthSignInWithEmailPasswordCommand build() {
    return AuthSignInWithEmailPasswordCommand(
      ref.watch(authServiceStateProvider),
    );
  }
}

/// A class representing the state of the [AuthSignUpWithEmailPasswordCommand]
/// command.
@riverpod
class AuthSignUpWithEmailPasswordCommandState
    extends _$AuthSignUpWithEmailPasswordCommandState {
  @override
  AuthSignUpWithEmailPasswordCommand build() {
    return AuthSignUpWithEmailPasswordCommand(
      ref.watch(authServiceStateProvider),
    );
  }
}

/// A class representing the state of the [AuthStepsModelState] model.
@riverpod
class AuthStepsModelState extends _$AuthStepsModelState {
  @override
  AuthStepsModel build() {
    return const AuthStepsModel();
  }
}

/// A class representing the state of the [AuthStepBackCommand] command.
@riverpod
class AuthStepBackCommandState extends _$AuthStepBackCommandState {
  @override
  AuthStepBackCommand build() {
    return AuthStepBackCommand(
      ref.watch(authStepsModelStateProvider),
      (AuthStepsModel value) {
        ref.read(authStepsModelStateProvider.notifier).state = value;
      },
    );
  }
}

/// A class representing the state of the [AuthNewStepCommand] command.
@riverpod
class AuthNewStepCommandState extends _$AuthNewStepCommandState {
  @override
  AuthNewStepCommand build() {
    return AuthNewStepCommand(
      ref.watch(authStepsModelStateProvider),
      (AuthStepsModel value) {
        ref.read(authStepsModelStateProvider.notifier).state = value;
      },
    );
  }
}
