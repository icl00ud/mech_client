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

        await firebaseAuth.createUserWithEmailAndPassword(
          email: accountUser.email.text,
          password: accountUser.password.text,
        );

        Map<String, dynamic> addressData = {
          'address': accountUser.address.address.text,
          'number': accountUser.address.number.text,
          'zip': accountUser.address.zip.text,
          'complement': accountUser.address.complement.text,
        };
        if (select == "Cliente") {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(accountUser.email.text)
              .set({
            'name': accountUser.name.text,
            'cpf': accountUser.cpf.text,
            'phone': accountUser.phone.text,
            'email': accountUser.email.text,
            'address': addressData,
            'password': accountUser.password.text,
            'type': select
          });
        } else {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(accountUser.email.text)
              .set({
            'name': accountUser.name.text,
            'cnpj': accountUser.cnpj.text,
            'phone': accountUser.phone.text,
            'email': accountUser.email.text,
            'address': addressData,
            'password': accountUser.password.text,
            'type': select
          });
        }
        FeedbackUtils.showSuccessSnackBar(
            context, 'Cadastro efetuado com sucesso!');

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
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
      print("Campos invalidos.");
    }
  }

  void getUser(AccountUser accountUser) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        String? userEmail = user.email;
        var collection = FirebaseFirestore.instance.collection('Users');
        DocumentSnapshot snapshot = await collection.doc(userEmail).get();

        if (snapshot.exists) {
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;
          accountUser.name.text = userData['name'] ?? 'campo vazio';
          accountUser.cpf.text = userData['cpf'] ?? 'campo vazio';
          accountUser.phone.text = userData['phone'] ?? 'campo vazio';
          accountUser.email.text = userData['email'] ?? 'campo vazio';
          accountUser.address.address.text =
              userData['address']['address'] ?? 'campo vazio';
          accountUser.address.number.text =
              userData['address']['number'] ?? 'campo vazio';
          accountUser.address.zip.text =
              userData['address']['zip'] ?? 'campo vazio';
          accountUser.address.complement.text =
              userData['address']['complement'] ?? 'campo vazio';
          accountUser.password.text = userData['password'] ?? 'campo vazio';
        }
      }
    } catch (e) {
      print('Erro ao obter informações do usuário: $e');
    }
  }

  Future<bool> updateUser(
      BuildContext context, String senhaAtual, AccountUser accountUser) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // cria um objeto AuthCredential para reautenticação
        var credential = EmailAuthProvider.credential(
          email: user.email!,
          password: senhaAtual,
        );

        // reautentique o usuário
        await user.reauthenticateWithCredential(credential);

        // atualiza o email e a senha do usuário
        await user.updateEmail(accountUser.email.text);
        await user.updatePassword(accountUser.password.text);

        var collection = FirebaseFirestore.instance.collection('Users');

        DocumentSnapshot snapshot = await collection.doc(user.uid).get();

        if (snapshot.exists) {
          // obtem os dados do documento
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;

          // atualize os campos desejados
          userData['name'] = accountUser.name.text;
          userData['email'] = accountUser.email.text;
          userData['phone'] = accountUser.phone.text;

          // atualiza os campos do map endereço
          Map<String, dynamic> addressData = {
            'address': accountUser.address.address.text,
            'number': accountUser.address.number.text,
            'zip': accountUser.address.zip.text,
            'complement': accountUser.address.complement.text,
          };
          //atualiza o map endereço pelo novo
          userData['address'] = addressData;

          await collection.doc(user.uid).update(userData);

          FeedbackUtils.showSuccessSnackBar(
              context, 'Cadastro atualizado com sucesso!');
          return true;
        }
      }
      return false;

      // validações do FireBaseAuthenticator
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        FeedbackUtils.showErrorSnackBar(
            context, 'A senha é muito fraca. Tente uma senha mais forte.');
      } else if (e.code == 'email-already-in-use') {
        FeedbackUtils.showErrorSnackBar(context,
            'Este e-mail já foi cadastrado. Por favor, faça login ou use outro e-mail.');
      }
      return false;
    } catch (e) {
      print('Erro ao atualizar informações do usuário: $e');

      return false;
    }
  }
}
