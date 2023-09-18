import 'package:flutter/material.dart';

class Vehicle extends StatelessWidget {
  const Vehicle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: RegisterVehicle(),
        ),
      ),
    );
  }
}

class RegisterVehicle extends StatelessWidget {
  const RegisterVehicle({Key? key}) : super(key: key);

  static const IconData directions_car_outlined =
      IconData(0xefc6, fontFamily: 'MaterialIcons');
  static const IconData add_circle_rounded =
      IconData(0xf52d, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Icon(
              directions_car_outlined,
              size: 50,
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Text(
              "Veículo",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFFF5C00),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            IconButton(
              onPressed: () {},
              color: const Color(0xFFFF5C00),
              iconSize: 40,
              icon: const Icon(add_circle_rounded),
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Text("Nenhum veículo cadastrado"),
          ],
        ),
      ),
    );
  }
}
