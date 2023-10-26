import 'package:flutter/material.dart';
import 'package:mech_client/models/account_user.dart';
import 'package:mech_client/screens/repair_screen.dart';
import 'package:mech_client/screens/user_account_screen.dart';
import 'package:mech_client/screens/vehicle_screen.dart';
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
      child: Column(
        children: <Widget>[
          if (accountUser != null)
            UserAccountsDrawerHeader(
              accountName: Text('Olá, ${accountUser!.name.text}'),
              accountEmail: Text(accountUser!.email.text),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Color(0xFFFF5C00),
                backgroundImage: NetworkImage('URL da foto do usuário'),
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFFF5C00),
              ),
            ),
          if (accountUser?.type == 'Cliente')
            ListTile(
              title: Text('Veículos'),
              leading: Icon(Icons.directions_car_outlined),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VehiclePage()));
              },
            ),
          ListTile(
            title: Text('Conserto'),
            leading: Icon(Icons.toll_outlined),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RepairPage()));
            },
          ),
          ListTile(
              title: Text('Conta'),
              leading: Icon(Icons.account_circle_outlined),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserAccount()));
              }),
          const Expanded(
            child:
                SizedBox(), // Espaço em branco para preencher o espaço restante
          ),
          const Divider(),
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
