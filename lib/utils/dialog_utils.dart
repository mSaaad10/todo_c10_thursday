import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoadingDialog(BuildContext context, String message,
      {bool isDismissible = true}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 8,
                  ),
                  Text(message),
                ],
              ),
            ),
        barrierDismissible: isDismissible);
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(
    BuildContext context,
    String message, {
    bool isDismissible = true,
    String? posActionTitle,
    String? negActionTitle,
    VoidCallback? posAction,
    VoidCallback? negAction,
  }) {
    List<Widget> actions = [];
    if (posActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);

            posAction?.call();
          },
          child: Text(posActionTitle)));
    }
    if (negActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            negAction?.call();
          },
          child: Text(negActionTitle)));
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: actions,
        );
      },
      barrierDismissible: isDismissible,
    );
  }
}
