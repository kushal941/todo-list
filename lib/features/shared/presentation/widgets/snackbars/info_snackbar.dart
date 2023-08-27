import 'package:flutter/material.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:todo/main.dart';

/// A custom snackbar used to show info.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showInfoSnackBar({
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
      iconData: Icons.info,
      iconAndTextColor: theme.colorScheme.surface,
    );
  } else {
    return null;
  }
}
