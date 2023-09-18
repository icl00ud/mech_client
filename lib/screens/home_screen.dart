import 'package:flutter/material.dart';
import 'package:mech_client/screens/user_screen.dart';
import 'package:mech_client/screens/vehicle_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'MechClient',
          style: TextStyle(
            color: Color(0xFFFF5C00), // Cor do título da AppBar
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black, // Cor dos ícones na AppBar
        ),
        leading: IconButton(
          icon: const Icon(Icons.sms_outlined),
          onPressed: () {
            // Ação ao pressionar o ícone à esquerda (menu, por exemplo)
            print('Ícone à esquerda pressionado');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.where_to_vote_outlined),
            onPressed: () {
              // Ação ao pressionar o ícone à direita (busca, por exemplo)
              print('Ícone à direita pressionado');
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            label: 'Veículos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Conta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.toll_outlined),
            label: 'Concerto',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF5C00),
        onTap: _onItemTapped,
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Vehicle(),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: User(),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page 3'),
    );
  }
}
