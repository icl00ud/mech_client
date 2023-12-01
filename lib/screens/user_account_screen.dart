import 'package:flutter/material.dart';
import 'package:mech_client/models/account_user_model.dart';
import 'package:mech_client/services/user_services.dart';
import 'package:mech_client/utils/constans_utils.dart';
import 'package:mech_client/widgets/User/forms_user_widget.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  AccountUser accountUser = AccountUser();
  UserServices userServices = UserServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AccountUser?>(
      future: userServices.getUser(accountUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Erro ao carregar os dados do usuário'),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: Text('Nenhum dado do usuário encontrado'),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 25),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              spreadRadius: 0,
                              color: Color.fromARGB(150, 0, 0, 0),
                              blurRadius: 4,
                              offset: Offset(0, 1)),
                        ],
                      ),
                      child: FormsUser(
                        accountUser: accountUser,
                        userServices: userServices,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
