import 'package:mech_client/services/feedback_utils.dart';
import 'package:mech_client/services/validationUser.dart';
import 'spinner_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mech_client/models/account_user.dart';
import 'package:mech_client/screens/home_screen.dart';
import 'package:mech_client/screens/login_screen.dart';

class UserServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void loginUser(BuildContext context, AccountUser accountUser) async {
    if (ValidationUser.validationLogin(context, accountUser)) {
      try {
        SpinnerUtils.showSpinner(context);
        await firebaseAuth.signInWithEmailAndPassword(
          email: accountUser.email.text,
          password: accountUser.password.text,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // ocultar o spinner em caso de erro
        SpinnerUtils.hideSpinner(context);

        if (e.code == 'user-not-found') {
          FeedbackUtils.showErrorSnackBar(
              context, 'Usuário não encontrado. Por favor, registre-se.');
        } else if (e.code == 'wrong-password') {
          FeedbackUtils.showErrorSnackBar(
              context, 'Senha inválida. Tente novamente.');
        }
      }
    } else {
      print("Campos invalidos.");
    }
  }

  void registerUser(
      BuildContext context, AccountUser accountUser, String select) async {
    if (ValidationUser.validationFields(context, accountUser, select)) {
      try {
        // exibe o spinner ao iniciar o registro
        SpinnerUtils.showSpinner(context);

        final UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: accountUser.email.text,
          password: accountUser.password.text,
        );

        final User? user = userCredential.user;
        if (user != null) {
          final Map<String, dynamic> addressData = {
            'address': accountUser.address.address.text,
            'number': accountUser.address.number.text,
            'zip': accountUser.address.zip.text,
            'complement': accountUser.address.complement.text,
          };

          final Map<String, dynamic> userData = {
            'name': accountUser.name.text,
            'email': accountUser.email.text,
            'phone': accountUser.phone.text,
            'address': addressData,
            'password': accountUser.password.text,
            'type': select,
          };

          if (select == "Cliente") {
            userData['cpf'] = accountUser.cpf.text;
          } else {
            userData['cnpj'] = accountUser.cnpj.text;
          }

          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .set(userData);

          FeedbackUtils.showSuccessSnackBar(
              context, 'Cadastro efetuado com sucesso!');

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
        }
      } on FirebaseAuthException catch (e) {
        SpinnerUtils.hideSpinner(context);

        if (e.code == 'weak-password') {
          FeedbackUtils.showErrorSnackBar(
              context, 'A senha é muito fraca. Tente uma senha mais forte.');
        } else if (e.code == 'email-already-in-use') {
          FeedbackUtils.showErrorSnackBar(context,
              'Este e-mail já foi cadastrado. Por favor, faça login ou use outro e-mail.');
        }
        print('Erro no registro: $e');
      }
    } else {
      print("Campos inválidos.");
    }
  }

  Future<AccountUser?> getUser(AccountUser accountUser) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        var collection = FirebaseFirestore.instance.collection('Users');
        DocumentSnapshot snapshot = await collection.doc(user.uid).get();
        if (snapshot.exists) {
          // Acessar os campos do DocumentSnapshot e atualizar o objeto AccountUser
          accountUser.name.text = snapshot['name'] ?? '';
          accountUser.email.text = snapshot['email'] ?? '';

          // Outros campos do AccountUser
          accountUser.phone.text = snapshot['phone'] ?? '';
          snapshot['type'] == "Cliente"
              ? accountUser.cpf.text = snapshot['cpf']
              : accountUser.cnpj.text = snapshot['cnpj'];
          accountUser.type = snapshot['type'] ?? '';
          accountUser.password.text = snapshot['password'];
          accountUser.confirmPassword.text = snapshot['password'];

          // Mapear os campos de endereço do Firestore para o objeto Address
          accountUser.address.address.text =
              snapshot['address']['address'] ?? '';
          accountUser.address.number.text = snapshot['address']['number'] ?? '';
          accountUser.address.zip.text = snapshot['address']['zip'] ?? '';
          accountUser.address.complement.text =
              snapshot['address']['complement'] ?? '';

          return accountUser;
        } else {
          print('Documento não encontrado para o usuário com ID ${user.uid}');
        }
      }
    } catch (e) {
      print('Erro ao obter informações do usuário: $e');
    }
    return null;
  }

  Future<bool> updateUser(
    BuildContext context,
    String password,
    AccountUser accountUser,
  ) async {
    try {
      if (ValidationUser.validationFields(
          context, accountUser, accountUser.type,
          validateCheckbox: false)) {
        SpinnerUtils.showSpinnerMessage(context, "Atualizando o cadastro...");

        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );

          await user.reauthenticateWithCredential(credential);

          await user.updateEmail(accountUser.email.text);
          await user.updatePassword(accountUser.password.text);

          final CollectionReference collection =
              FirebaseFirestore.instance.collection('Users');

          final DocumentSnapshot snapshot =
              await collection.doc(user.uid).get();

          if (snapshot.exists) {
            final Map<String, dynamic> userData =
                snapshot.data() as Map<String, dynamic>;

            userData['name'] = accountUser.name.text;
            userData['email'] = accountUser.email.text;
            userData['phone'] = accountUser.phone.text;
            userData['password'] = accountUser.password.text;

            final Map<String, dynamic> addressData = {
              'address': accountUser.address.address.text,
              'number': accountUser.address.number.text,
              'zip': accountUser.address.zip.text,
              'complement': accountUser.address.complement.text,
            };

            userData['address'] = addressData;

            await collection.doc(user.uid).update(userData);

            ScaffoldMessenger.of(context)
                .removeCurrentSnackBar(); // Remove o SnackBar
            FeedbackUtils.showSuccessSnackBar(
                context, 'Cadastro atualizado com sucesso!');
            return true;
          }
        }
      }
      return false;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .removeCurrentSnackBar(); // Remove o SnackBar
      if (e.code == 'weak-password') {
        FeedbackUtils.showErrorSnackBar(
            context, 'A senha é muito fraca. Tente uma senha mais forte.');
      } else if (e.code == 'email-already-in-use') {
        FeedbackUtils.showErrorSnackBar(context,
            'Este e-mail já foi cadastrado. Por favor, faça login ou use outro e-mail.');
      }
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .removeCurrentSnackBar(); // Remove o SnackBar
      print('Erro ao atualizar informações do usuário: $e');
      return false;
    }
  }
}
