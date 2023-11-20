import 'package:flutter/material.dart';
import 'package:mech_client/utils/constans_utils.dart';

class SpinnerUtils {
  // criar spinner
  static showSpinner(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      },
    );
  }

  static showSpinnerMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
        duration: const Duration(days: 1),
      ),
    );
  }

  // ocultar o spinner
  static void hideSpinner(BuildContext context) {
    Navigator.of(context).pop();
  }
}
