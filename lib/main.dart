import 'package:flutter/material.dart';
import 'package:mech_client/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_config.dart';

void main() async {
  // Certifique-se de inicializar o Firebase antes de executar o aplicativo
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
