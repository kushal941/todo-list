import 'package:todo/features/shared/presentation/widgets/snackbars/custom_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:todo/main.dart';

/// A custom snackbar used to show success.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showWarningSnackBar({
  required String text,
  String? subText,
  // required BuildContext context,
}) {
  BuildContext? context = rootScaffoldMessengerKey.currentContext;

  if (context != null) {
    final ThemeData theme = Theme.of(context);

    return showCustomSnackBar(
      text: text,
      subText: subText,
      iconData: Icons.warning_rounded,
      duration: const Duration(seconds: 30),
      // Using custom colors.
      iconAndTextColor: theme.colorScheme.error,
    );
  } else {
    return null;
  }
}
