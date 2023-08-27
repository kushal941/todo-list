import 'package:todo/constants/other_constants.dart';
import 'package:todo/features/shared/presentation/widgets/onboarding/screen_content_overlay_box.dart';
import 'package:flutter/material.dart';

/// A widget that represents the content for the welcome step.
class WelcomeStepContent extends StatelessWidget {
  /// Creates a [WelcomeStepContent].
  ///
  /// The [onGetStarted] parameter is optional.
  const WelcomeStepContent({
    Key? key,
    this.onGetStarted,
    required this.isProcessing,
  }) : super(key: key);

  /// Callback function invoked when the "Get Started" button is pressed.
  final void Function()? onGetStarted;

  /// Is true if processing is in progress.
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    return StepOverlayContent(
      isProcessing: isProcessing,
      titleText: "Welcome to $appName App!",
      bodyText: "The slickest todo app in the world.",
      content: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          FilledButton(
            onPressed: isProcessing ? null : onGetStarted,
            child: const Text(
              "Get Started",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
