import 'package:flutter/material.dart';
import 'package:mech_client/models/vehicle_model.dart';
import 'package:mech_client/services/vehicle_services.dart';
import 'package:mech_client/utils/constans_utils.dart';
import 'package:mech_client/widgets/forms_vehicle_widget.dart';

class VehiclePage extends StatelessWidget {
  const VehiclePage({Key? key}) : super(key: key);

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
  Vehicle vehicle = Vehicle();
  VehicleServices vehicleServices = VehicleServices();
  List<Vehicle> userVehicles =
      []; // Lista para armazenar os veículos associados ao usuário

  @override
  void initState() {
    super.initState();
    _loadUserVehicles();
  }

  Future<void> _loadUserVehicles() async {
    List<Vehicle> vehicles = await vehicleServices.getVehiclesForUser();

    setState(() {
      userVehicles = vehicles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Column(
                children: [
                  Icon(
                    Icons.directions_car_filled_outlined,
                    size: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Veículo',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                ],
              ),
              FormsVehicle(vehicle: vehicle),
            ],
          ),
        ),
      ),
    );
  }
}
