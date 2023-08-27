import 'package:todo/features/shared/presentation/widgets/onboarding/overlay_container.dart';
import 'package:flutter/material.dart';

/// A widget that displays an overlay box for content of the screen.
class ScreenStepOverlay extends StatelessWidget {
  /// Creates an [ScreenStepOverlay].
  ///
  /// The [child] parameter is required.
  const ScreenStepOverlay({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The widget displayed in the overlay box.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: OverlayContainer(
          cornerRadius: 4,
          child: IntrinsicWidth(
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A widget that displays content for the auth screen.
class StepOverlayContent extends StatelessWidget {
  /// Creates an [StepOverlayContent].
  ///
  /// The [titleText], [bodyText], and [contentWidget] parameters are required.
  const StepOverlayContent({
    Key? key,
    required this.isProcessing,
    required this.titleText,
    required this.bodyText,
    required this.content,
  }) : super(key: key);

  /// The title text displayed in the overlay box.
  final String titleText;

  /// The body text displayed in the overlay box.
  final String bodyText;

  /// The content is displayed below the title and body text in the overlay box.
  final Widget content;

  /// Is processing in progress.
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    // The theme of the app in the current context.
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        isProcessing
            ? const LinearProgressIndicator()
            : const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(
            top: 12.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                titleText,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                bodyText,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Divider(),
              content,
            ],
          ),
        ),
      ],
    );
  }
}
