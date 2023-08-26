import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Importando o arquivo login_screen.dart

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}