import 'package:flutter/material.dart';
import 'package:mech_client/models/account_user.dart';
import 'package:mech_client/services/user_services.dart';

class CustomDrawer extends StatefulWidget {
  final VoidCallback onSignOut;

  CustomDrawer({required this.onSignOut});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  AccountUser? accountUser;
  UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // função para carregar os dados do usuário
  void _loadUserData() async {
    final user = await userServices.getUser(accountUser ?? AccountUser());
    setState(() {
      accountUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          if (accountUser != null)
            UserAccountsDrawerHeader(
              accountName: Text('Olá, ${accountUser!.name.text}'),
              accountEmail: Text(accountUser!.email.text),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage('URL da foto do usuário'),
              ),
            ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: widget.onSignOut,
          ),
        ],
      ),
    );
  }
}
