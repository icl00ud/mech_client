import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mech_client/models/account_user_model.dart';
import 'package:mech_client/utils/constans_utils.dart';
import 'package:mech_client/widgets/custom_drawer_widget.dart';
import 'package:mech_client/screens/login_screen.dart';
import 'package:mech_client/screens/repair_screen.dart';
import 'package:mech_client/screens/user_account_screen.dart';
import 'package:mech_client/services/user_services.dart';

void main() {
  runApp(MaterialApp(home: HomeMech()));
}

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
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _selectedIndex == 0 ? 'Conta' : 'Conserto',
          style: const TextStyle(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
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
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.where_to_vote_outlined,
              size: 25,
            ),
            color: primaryColor,
            onPressed: () {
              singOut();
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
            icon: Icon(Icons.build_outlined),
            label: 'Conserto',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
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
