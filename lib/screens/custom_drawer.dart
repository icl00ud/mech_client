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
  AccountUser accountUser = AccountUser();
  UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // função para carregar os dados do usuário
  void _loadUserData() async {
    final user = await userServices.getUser(AccountUser());
    setState(() {
      accountUser = user!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Olá, ${accountUser.name.text}'),
            accountEmail: Text(accountUser.email.text),
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
          if (accountUser.type == 'Cliente')
            ListTile(
              title: const Text('Veículos'),
              leading: const Icon(Icons.directions_car_outlined),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VehiclePage()));
              },
            ),
          ListTile(
            title: const Text('Conserto'),
            leading: const Icon(Icons.toll_outlined),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const RepairPage()));
            },
          ),
          ListTile(
              title: const Text('Conta'),
              leading: const Icon(Icons.account_circle_outlined),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserAccount()));
              }),
          const Expanded(
            child:
                SizedBox(), // Espaço em branco para preencher o espaço restante
          ),
          const Divider(),
          ListTile(
              title: const Text('Excluir Conta'),
              leading: const Icon(Icons.delete_forever_outlined),
              onTap: () {
                showDialog(
                  barrierColor:
                      const Color.fromARGB(255, 39, 39, 39).withOpacity(0.7),
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Excluir Conta'),
                      content: const Text(
                          'Você tem certeza de que deseja excluir sua conta?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Fecha o diálogo sem excluir a conta
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                                color: Color(
                                  0xFFFF5C00,
                                ),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            userServices.deleteUser(context, accountUser);
                          },
                          child: const Text('Confirmar',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    );
                  },
                );
              }),
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
