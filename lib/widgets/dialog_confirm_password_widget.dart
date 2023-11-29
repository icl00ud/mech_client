import 'package:flutter/material.dart';
import 'package:mech_client/utils/constans_utils.dart';
import 'package:mech_client/utils/feedback_utils.dart';

class DialogConfirmPassword extends StatefulWidget {
  final String passwordCorrect;

  const DialogConfirmPassword({
    required this.passwordCorrect,
    Key? key,
  }) : super(key: key);

  @override
  State<DialogConfirmPassword> createState() => _DialogConfirmPasswordState();
}

class _DialogConfirmPasswordState extends State<DialogConfirmPassword> {
  String password = '';
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        icon: const Icon(
          Icons.lock_outline,
          size: 30,
        ),
        title: const Text('Digite sua senha:'),
        content: TextField(
          obscureText: !isPasswordVisible,
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Senha',
            focusColor: primaryColor,
            border: InputBorder.none,
            filled: true,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              child: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancelar',
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              if (password == widget.passwordCorrect) {
                Navigator.pop(context, true);
              } else {
                FeedbackUtils.showErrorSnackBar(
                    context, "A senha está incorreta!");
                Navigator.pop(context, false);
              }
            },
            child: const Text(
              'Confirmar',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
