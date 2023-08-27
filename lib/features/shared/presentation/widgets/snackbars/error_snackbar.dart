import 'package:flutter/material.dart';
import 'package:todo/features/shared/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:todo/main.dart';

/// A custom snackbar used to show errors.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showErrorSnackBar({
  required String text,
  String? subText,
  // required BuildContext context,
}) {
  ScaffoldMessengerState? scaffold = rootScaffoldMessengerKey.currentState;

  if (scaffold != null) {
    BuildContext context = scaffold.context;

    final ThemeData theme = Theme.of(context);

    return showCustomSnackBar(
      text: text,
      subText: subText,
      iconData: Icons.cancel,
      iconAndTextColor: theme.colorScheme.error,
      duration: const Duration(seconds: 30),
      action: SnackBarAction(
        label: 'Logs',
        onPressed: () {
          rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
        },
      ),
    );
  } else {
    return null;
  }
}
