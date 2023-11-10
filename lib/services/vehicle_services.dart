import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mech_client/models/vehicle.dart';

import 'package:firebase_auth/firebase_auth.dart';

class VehicleServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void registerVehicle(Vehicle vehicle) async {
    try {
      final User? user = firebaseAuth.currentUser;

      if (user != null) {
        vehicle.idUser = user.uid;

        // armazenando dados
        Map<String, dynamic> vehicleData = {
          'id': vehicle.idUser,
          'plate': vehicle.plate.text,
          'model': vehicle.model.text,
          'color': vehicle.color.text,
          'brand': vehicle.brand.text,
          'gearShift': vehicle.gearShift.text,
          'yearFabrication': vehicle.yearFabrication.text,
        };

        //inserindo dados do Veiculo
        await FirebaseFirestore.instance
            .collection('Vehicles')
            .doc(vehicle.plate.text)
            .set(vehicleData);
      }

      // insere campo placa na coleção do usuario
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.uid)
          .update(
        {
          'vehicle.plate': vehicle.plate.text,
        },
      );
    } catch (e) {
      print('Erro ao registrar as informações do veículo: $e');
    }
  }

  Future<Vehicle?> getVehicle(Vehicle vehicle) async {
    try {
      User? user = firebaseAuth.currentUser;

      if (user != null) {
        var collection = FirebaseFirestore.instance.collection('Vehicles');

        DocumentSnapshot snapshot =
            await collection.doc(vehicle.plate.text).get();

        if (snapshot.exists) {
          // Preencha os controladores do objeto Vehicle com os dados obtidos.

          vehicle.brand.text = snapshot['brand'] ?? 'campo vazio';
          vehicle.color.text = snapshot['color'] ?? 'campo vazio';
          vehicle.model.text = snapshot['model'] ?? 'campo vazio';
          vehicle.gearShift.text = snapshot['gearShift'] ?? 'campo vazio';
          vehicle.yearFabrication.text =
              snapshot['yearFabrication'] ?? 'campo vazio';
          vehicle.plate.text = snapshot['plate'] ?? 'campo vazio';

          return vehicle;
        }
      }
    } catch (e) {
      print('Erro ao obter informações do veículo: $e');
    }
  }
}
