import 'package:todo/features/authentication/presentation/states/auth_state.dart';
import 'package:todo/features/authentication/presentation/widgets/auth_screen.dart';
import 'package:todo/features/dashboard/presentation/widgets/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The initial screen of the app.
class InitialScreen extends ConsumerWidget {
  /// Creates a [InitialScreen].
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<bool> authStateAsync = ref.watch(authStateProvider);

    return authStateAsync.when(
      data: (bool authState) =>
          authState ? const HomeScreen() : const AuthScreen(),
      loading: () => const CircularProgressIndicator(),
      error: (Object err, StackTrace stack) => Text('Error: $err'),
    );
  }
}
