import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle extends StatelessWidget {
  const Vehicle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: RegisterVehicle(),
        ),
      ),
    );
  }
}

class RegisterVehicle extends StatefulWidget {
  const RegisterVehicle({Key? key}) : super(key: key);

  @override
  _RegisterVehicleState createState() => _RegisterVehicleState();
}

class _RegisterVehicleState extends State<RegisterVehicle> {
  List<String> vehicles = []; // Lista de veículos do usuário

  @override
  void initState() {
    super.initState();
    // Chamada para buscar a lista de veículos do usuário
    fetchUserVehicles();
  }

  Future<void> fetchUserVehicles() async {
    try {
      await Firebase.initializeApp();

      var userVehiclesCollection = FirebaseFirestore.instance.collection('Vehicles');

      var querySnapshot = await userVehiclesCollection.get();

      print(querySnapshot);


      setState(() {
        vehicles = querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print('Erro ao buscar veículos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: vehicles.length + 1, // +1 para o botão "Adicionar Veículo"
          itemBuilder: (BuildContext context, int index) {
            if (index == vehicles.length) {
              // Último item da lista para adicionar um veículo
              return GestureDetector(
                onTap: () {
                  // Implemente aqui a lógica para adicionar um veículo ao Firebase
                },
                child: const Card(
                  child: ListTile(
                    leading: Icon(Icons.add_circle_rounded),
                    title: Text('Adicionar Veículo'),
                  ),
                ),
              );
            } else {
              // Item da lista correspondente a um veículo cadastrado
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.directions_car_outlined),
                  title: Text(vehicles[index]),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}