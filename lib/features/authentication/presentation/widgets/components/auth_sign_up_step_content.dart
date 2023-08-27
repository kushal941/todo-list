import 'package:todo/features/authentication/domain/models/account_model.dart';
import 'package:todo/features/shared/presentation/widgets/onboarding/screen_content_overlay_box.dart';
import 'package:flutter/material.dart';

/// A widget that represents the content for the sign up step.
class SignUpStepContent extends StatefulWidget {
  /// Creates a [SignUpStepContent].
  ///
  /// The [onBack] and [onSignUp] parameters are optional callbacks for back and
  /// next actions.
  /// The [isProcessing] parameter is required.
  const SignUpStepContent({
    Key? key,
    this.onBack,
    this.onSignUp,
    required this.isProcessing,
  }) : super(key: key);

  /// Callback function invoked when the "Back" button is pressed.
  final void Function()? onBack;

  /// Callback function invoked when the "Sign Up" button is pressed.
  final void Function(CredentialsModel)? onSignUp;

  /// Is true if processing is in progress.
  final bool isProcessing;

  @override
  State<SignUpStepContent> createState() => _SignUpStepContentState();
}

class _SignUpStepContentState extends State<SignUpStepContent> {
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
    return IntrinsicWidth(
      child: StepOverlayContent(
        isProcessing: widget.isProcessing,
        titleText: "Sign Up",
        bodyText: "Create an account to continue",
        content: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                      onPressed: widget.isProcessing || widget.onSignUp == null
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                widget.onSignUp!(
                                  CredentialsModel(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                      child: const Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
