import 'package:flutter/material.dart';

/// A widget that displays an overlay container with optional child widget.
class OverlayContainer extends StatelessWidget {
  /// Creates an [OverlayContainer].
  ///
  /// The [child], [cornerRadius], [padding], and [margin] parameters are
  /// optional.
  const OverlayContainer({
    Key? key,
    this.child,
    this.cornerRadius = 0,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
  }) : super(key: key);

  /// The child widget to be displayed inside the overlay container.
  final Widget? child;

  /// The corner radius of the overlay container.
  final double cornerRadius;

  /// The padding around the child widget inside the overlay container.
  final EdgeInsetsGeometry padding;

  /// The margin around the overlay container.
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    // The theme of the app in the current context.
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: margin,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.7),
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        child: child != null ? Padding(padding: padding, child: child) : null,
      ),
    );
  }
}
