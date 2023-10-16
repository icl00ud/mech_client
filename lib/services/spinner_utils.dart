import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinnerUtils {
  // criar spinner
  static showSpinner(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: SpinKitFadingCircle(
            color: Color(0xFFFF5C00),
            size: 50.0, // Tamanho do spinner
          ),
        );
      },
    );
  }

  // ocultar o spinner
  static void hideSpinner(BuildContext context) {
    Navigator.of(context).pop();
  }
}
