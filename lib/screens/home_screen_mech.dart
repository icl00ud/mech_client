import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mech_client/models/account_user.dart';
import 'package:mech_client/widgets/custom_drawer_widget.dart';
import 'package:mech_client/screens/login_screen.dart';
import 'package:mech_client/screens/repair_screen.dart';
import 'package:mech_client/screens/user_account_screen.dart';
import 'package:mech_client/services/user_services.dart';

class HomeMech extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenMech(),
    );
  }
}

class HomeScreenMech extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenMech> {
  int _selectedIndex = 0;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final List<Widget> _pages = [
    Page1(),
    Page2(),
  ];

  UserServices userServices = UserServices();

  @override
  void initState() {
    userServices.getUser(accountUser);
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AccountUser accountUser = AccountUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Adicione a chave global ao Scaffold
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'MechClient',
          style: TextStyle(
            color: Color(0xFFFF5C00),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            size: 25,
          ),
          onPressed: () {
            // Abra o menu lateral ao pressionar o ícone
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.where_to_vote_outlined,
              size: 25,
            ),
            color: Color(0xFFFF5C00),
            onPressed: () {
              // Ação para sair (exemplo: singOut())
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        onSignOut: () {
          singOut();
        },
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Conta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.toll_outlined),
            label: 'Conserto',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF5C00),
        onTap: _onItemTapped,
      ),
    );
  }

  void singOut() async {
    await _firebaseAuth.signOut().then(
          (user) => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          ),
        );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserAccount(),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RepairPage(),
    );
  }
}
