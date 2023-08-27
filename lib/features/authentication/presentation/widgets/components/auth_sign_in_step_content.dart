import 'package:todo/features/authentication/domain/models/account_model.dart';
import 'package:todo/features/shared/presentation/widgets/onboarding/screen_content_overlay_box.dart';
import 'package:flutter/material.dart';

/// A widget that represents the content for the sign in step.
class SignInStepContent extends StatefulWidget {
  /// Creates a [SignInStepContent].
  ///
  /// The [onBack], [onSignIn], [onSignUpStep] and [onSignInWithGoogle]
  /// parameters are optional.
  /// The [isProcessing] parameter is required.
  const SignInStepContent({
    Key? key,
    this.onBack,
    this.onSignIn,
    this.onSignUpStep,
    this.onSignInWithGoogle,
    required this.isProcessing,
  }) : super(key: key);

  /// Callback function invoked when the "Back" button is pressed.
  final void Function()? onBack;

  /// Callback function invoked when the "Sign In" button is pressed.
  final void Function(CredentialsModel)? onSignIn;

  /// Callback function invoked when the go to sign up button is pressed.
  final void Function()? onSignUpStep;

  /// Callback function invoked when the "Sign In with Google" button is
  /// pressed.
  final void Function()? onSignInWithGoogle;

  /// Is true if processing is in progress.
  final bool isProcessing;

  @override
  State<SignInStepContent> createState() => _SignInStepContentState();
}

class _SignInStepContentState extends State<SignInStepContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The theme of the app in the current context.
    final ThemeData theme = Theme.of(context);

    return IntrinsicWidth(
      child: StepOverlayContent(
        isProcessing: widget.isProcessing,
        titleText: "Login",
        bodyText: "Login to your account to continue",
        content: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FilledButton.tonalIcon(
                onPressed:
                    widget.isProcessing || widget.onSignInWithGoogle == null
                        ? null
                        : () {
                            widget.onSignInWithGoogle!();
                          },
                icon: const Icon(Icons.login),
                label: const Text(
                  "Sign in with Google",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              const Text("OR"),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: "Email",
                  hintText: "johndoe@email.com",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: "Password",
                  hintText: "•••••••••••",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: widget.isProcessing ? null : widget.onBack,
                      child: const Text(
                        "Back",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    FilledButton(
                      onPressed: widget.isProcessing || widget.onSignIn == null
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                widget.onSignIn!(
                                  CredentialsModel(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                      child: const Text(
                        "Login",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an account?",
                    style: theme.textTheme.labelMedium,
                    softWrap: true,
                    textAlign: TextAlign.start,
                  ),
                  TextButton(
                    onPressed:
                        widget.isProcessing || widget.onSignUpStep == null
                            ? null
                            : () {
                                widget.onSignUpStep!();
                              },
                    child: const Text("Sign up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
