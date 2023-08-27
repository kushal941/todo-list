import 'package:todo/constants/other_constants.dart';
import 'package:todo/features/authentication/domain/models/account_model.dart';
import 'package:todo/features/authentication/domain/models/auth_steps_model.dart';
import 'package:todo/features/authentication/presentation/states/auth_state.dart';
import 'package:todo/features/authentication/presentation/widgets/components/auth_sign_in_step_content.dart';
import 'package:todo/features/authentication/presentation/widgets/components/auth_sign_up_step_content.dart';
import 'package:todo/features/authentication/presentation/widgets/components/auth_welome_step_content.dart';
import 'package:todo/features/shared/presentation/widgets/onboarding/overlay_container.dart';
import 'package:todo/features/shared/presentation/widgets/onboarding/screen_content_overlay_box.dart';
import 'package:todo/features/shared/presentation/widgets/onboarding/scrolling_covers_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that represents the auth screen.
class AuthScreen extends StatelessWidget {
  /// Creates a [AuthScreen].
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            appName,
            style: TextStyle(),
          ),
          backgroundColor:
              Theme.of(context).colorScheme.surface.withOpacity(0.7),
        ),
        body: const Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // ScrollingCoversBackground(),
            OverlayContainer(),
            AuthContent(),
          ],
        ),
      ),
    );
  }
}

/// A widget that represents the content above the background and overlay of the
/// auth screen.
class AuthContent extends ConsumerStatefulWidget {
  /// Creates a [AuthContent].
  const AuthContent({super.key});

  @override
  ConsumerState<AuthContent> createState() => _AuthContentState();
}

class _AuthContentState extends ConsumerState<AuthContent> {
  // Is true if any of the onboarding commands are currently running.
  bool isProcessing = false;

  // Handles the auth steps back action.
  Future<void> onBack() async {
    setState(() {
      isProcessing = true;
    });
    await ref.read(authStepBackCommandStateProvider).run();
    setState(() {
      isProcessing = false;
    });
  }

  // Handles the auth sign up step button action.
  Future<void> onSignUpStep() async {
    setState(() {
      isProcessing = true;
    });
    await ref.read(authNewStepCommandStateProvider).run(AuthStep.signUpStep);
    setState(() {
      isProcessing = false;
    });
  }

  // Handles the get started button action.
  Future<void> onGetStarted() async {
    setState(() {
      isProcessing = true;
    });
    await ref.read(authNewStepCommandStateProvider).run(AuthStep.signInStep);
    setState(() {
      isProcessing = false;
    });
  }

  // Handles the auth sign in with google button action.
  Future<void> onSignInWithGoogle() async {
    setState(() {
      isProcessing = true;
    });
    await ref.read(authSignInWithGoogleCommandStateProvider).run();
    setState(() {
      isProcessing = false;
    });
  }

  // Handles the auth sign in button action.
  Future<void> onSignIn(CredentialsModel credentialsModel) async {
    setState(() {
      isProcessing = true;
    });
    await ref
        .read(authSignInWithEmailPasswordCommandStateProvider)
        .run(credentialsModel);
    setState(() {
      isProcessing = false;
    });
  }

  // Handles the auth sign up button action.
  Future<void> onSignUp(CredentialsModel credentialsModel) async {
    setState(() {
      isProcessing = true;
    });
    await ref
        .read(authSignUpWithEmailPasswordCommandStateProvider)
        .run(credentialsModel);
    setState(() {
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current state of the auth steps model.
    AuthStepsModel authStepsModel = ref.watch(authStepsModelStateProvider);

    // Get the current step of the auth process.
    AuthStep? authCurrentStep = authStepsModel.authSteps.isNotEmpty
        ? authStepsModel.authSteps.last
        : null;

    return WillPopScope(
      onWillPop: () async {
        // Handle device back button action.
        if (authCurrentStep != null) {
          // If the current step is not the first step, go back to the previous
          // auth step.
          await onBack();
          // Prevent the default back button behavior.
          return false;
        }
        // Default back button behavior.
        return true;
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        // Explanation for using the RepaintBoundary to fix assertion error when
        // rapidly clicking buttons:
        // When you click a button to trigger a transition between auth
        // steps, Flutter starts animating the transition. This rapid clicking
        // can create a situation where multiple animations are running
        // simultaneously, attempting to modify the same widget in an
        // inconsistent state. Flutter's rendering system expects each widget to
        // be a repaint boundary, meaning it can be independently painted and
        // animated. However, when multiple animations are applied to the same
        // widget simultaneously, it violates this assumption. This causes
        // 'node.isRepaintBoundary: is not true' assertion error occurs when
        // trying to animate a widget that is not a repaint boundary.
        // So, by wrapping the auth steps with RepaintBoundary, we
        // indicate to Flutter that each step should be treated as a separate
        // layer for painting and animation purposes. This ensures that each
        // animation is applied independently, preventing conflicts between
        // multiple simultaneous animations and resolving the assertion error.

        // Explanation for using keys:
        // AnimatedSwitcher uses keys to identify different child widgets and
        // animate the transitions between them. When the key associated with a
        // child changes, AnimatedSwitcher understands that a different widget
        // is being shown, and it animates the transition accordingly.
        child: RepaintBoundary(
          key: ValueKey<String>(
            '$authCurrentStep',
          ),
          child: ScreenStepOverlay(
            child: GetStepContent(
              authCurrentStep: authCurrentStep,
              isProcessing: isProcessing,
              onBack: onBack,
              onGetStarted: onGetStarted,
              onSignUpStep: onSignUpStep,
              onSignInWithGoogle: onSignInWithGoogle,
              onSignIn: onSignIn,
              onSignUp: onSignUp,
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that provides auth steps content to [AuthContent]
/// widget based on the current step.
class GetStepContent extends StatelessWidget {
  /// Creates a [GetStepContent].
  ///
  /// The [serverCreationCurrentStep] and [serverJoiningCurrentStep] parameters
  /// are required.
  /// The [onBack], [onServerStatusVerifyNextStep],
  ///  [onServerAccountCreationNextStep], [onMakeServer], [onJoinServer], and
  ///  [isProcessing] parameters are optional.
  const GetStepContent({
    Key? key,
    required this.authCurrentStep,
    this.onBack,
    this.onGetStarted,
    this.onSignUpStep,
    this.onSignInWithGoogle,
    this.onSignIn,
    this.onSignUp,
    required this.isProcessing,
  }) : super(key: key);

  /// The current step for the auth process.
  final AuthStep? authCurrentStep;

  /// Callback function invoked when the "Back" button is pressed.
  final void Function()? onBack;

  /// Callback function invoked when the "Sign In with Google" button is
  /// pressed.
  final void Function()? onSignInWithGoogle;

  /// Callback function invoked when the "Get Started" button is pressed.
  final void Function()? onGetStarted;

  /// Callback function invoked when the go to sign up button is pressed.
  final void Function()? onSignUpStep;

  /// Callback function invoked when the "Sign In" button is pressed.
  final void Function(CredentialsModel)? onSignIn;

  /// Callback function invoked when the "Sign Up" button is pressed.
  final void Function(CredentialsModel)? onSignUp;

  /// Is true if any of the auth commands are currently running.
  final bool isProcessing;
  @override
  Widget build(BuildContext context) {
    if (authCurrentStep == null) {
      return WelcomeStepContent(
        onGetStarted: onGetStarted,
        isProcessing: isProcessing,
      );
    } else if (authCurrentStep != null) {
      if (authCurrentStep == AuthStep.signInStep) {
        return SignInStepContent(
          onBack: onBack,
          onSignUpStep: onSignUpStep,
          onSignIn: onSignIn,
          onSignInWithGoogle: onSignInWithGoogle,
          isProcessing: isProcessing,
        );
      } else if (authCurrentStep == AuthStep.signUpStep) {
        return SignUpStepContent(
          onBack: onBack,
          onSignUp: onSignUp,
          isProcessing: isProcessing,
        );
      } else {
        return const SizedBox();
      }
    } else {
      return const SizedBox();
    }
  }
}
