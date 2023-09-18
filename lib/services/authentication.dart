import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  registerUser({
    required String name,
    required String cpf,
    required String phone,
    required String email,
    required String zip,
    required String number,
    required String password,
  }) {
    _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }
}