import 'package:todo/features/shared/presentation/widgets/snackbars/custom_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:todo/main.dart';

/// A custom snackbar used to show success.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSuccessSnackBar({
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
      iconData: Icons.check_circle,
      // Using custom colors.
      iconAndTextColor: Colors.green,
    );
  } else {
    return null;
  }
}
