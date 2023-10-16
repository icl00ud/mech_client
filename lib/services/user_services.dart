import 'package:mech_client/models/mechanic.dart';
import 'package:mech_client/services/feedback_utils.dart';
import 'package:mech_client/services/validationUser.dart';
import 'spinner_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mech_client/models/client.dart';
import 'package:mech_client/screens/home_screen.dart';
import 'package:mech_client/screens/login_screen.dart';

class UserServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void loginUser(BuildContext context, Client client) async {
    if (ValidationUser.validationLogin(context, client)) {
      try {
        SpinnerUtils.showSpinner(context);
        await firebaseAuth.signInWithEmailAndPassword(
          email: client.email.text,
          password: client.password.text,
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

  void registerClient(BuildContext context, Client client) async {
    if (ValidationUser.validationClientFields(context, client)) {
      try {
        // exibe o spinner ao iniciar o registro
        SpinnerUtils.showSpinner(context);

        await firebaseAuth.createUserWithEmailAndPassword(
          email: client.email.text,
          password: client.password.text,
        );

        User? user = firebaseAuth.currentUser;

        Map<String, dynamic> addressData = {
          'address': client.address.address.text,
          'number': client.address.number.text,
          'zip': client.address.zip.text,
          'complement': client.address.complement.text,
        };

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user?.uid)
            .set({
          'name': client.name.text,
          'cpf': client.cpf.text,
          'phone': client.phone.text,
          'email': client.email.text,
          'address': addressData,
          'password': client.password.text,
        });

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

  void getUser(Client client) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        var collection = FirebaseFirestore.instance.collection('Users');
        DocumentSnapshot snapshot = await collection.doc(user.uid).get();

        if (snapshot.exists) {
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;
          client.name.text = userData['name'] ?? 'campo vazio';
          client.cpf.text = userData['cpf'] ?? 'campo vazio';
          client.phone.text = userData['phone'] ?? 'campo vazio';
          client.email.text = userData['email'] ?? 'campo vazio';
          client.address.address.text =
              userData['address']['address'] ?? 'campo vazio';
          client.address.number.text =
              userData['address']['number'] ?? 'campo vazio';
          client.address.zip.text = userData['address']['zip'] ?? 'campo vazio';
          client.address.complement.text =
              userData['address']['complement'] ?? 'campo vazio';
          client.password.text = userData['password'] ?? 'campo vazio';
        }
      }
    } catch (e) {
      print('Erro ao obter informações do usuário: $e');
    }
  }

  void registerMechanic(BuildContext context, Mechanic mechanic) async {
    if (ValidationUser.validationMechanicFields(context, mechanic)) {
      try {
        // exibe o spinner ao iniciar o registro
        SpinnerUtils.showSpinner(context);

        await firebaseAuth.createUserWithEmailAndPassword(
          email: mechanic.email.text,
          password: mechanic.password.text,
        );

        User? user = firebaseAuth.currentUser;

        Map<String, dynamic> addressData = {
          'address': mechanic.address.address.text,
          'number': mechanic.address.number.text,
          'zip': mechanic.address.zip.text,
          'complement': mechanic.address.complement.text,
        };

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user?.uid)
            .set({
          'name': mechanic.name.text,
          'cnpj': mechanic.cnpj.text,
          'phone': mechanic.phone.text,
          'email': mechanic.email.text,
          'address': addressData,
          'password': mechanic.password.text,
        });

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

  Future<bool> updateUser(
      BuildContext context, String senhaAtual, Client client) async {
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
        await user.updateEmail(client.email.text);
        await user.updatePassword(client.password.text);

        var collection = FirebaseFirestore.instance.collection('Users');

        DocumentSnapshot snapshot = await collection.doc(user.uid).get();

        if (snapshot.exists) {
          // obtem os dados do documento
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;

          // atualize os campos desejados
          userData['name'] = client.name.text;
          userData['email'] = client.email.text;
          userData['phone'] = client.phone.text;

          // atualiza os campos do map endereço
          Map<String, dynamic> addressData = {
            'address': client.address.address.text,
            'number': client.address.number.text,
            'zip': client.address.zip.text,
            'complement': client.address.complement.text,
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
