import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback function;
  final String text;
  const Button({required this.text, required this.function, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF5C00),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0), // Arredondamento da borda
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
