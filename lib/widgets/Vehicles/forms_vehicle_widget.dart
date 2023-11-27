import 'package:flutter/material.dart';
import 'package:mech_client/models/vehicle_model.dart';
import 'package:mech_client/services/vehicle_services.dart';
import 'package:mech_client/utils/constans_utils.dart';
import 'package:mech_client/widgets/Vehicles/vehicle_create_widget.dart';
import 'package:mech_client/widgets/Vehicles/vehicle_update_widget.dart';

class FormsVehicle extends StatefulWidget {
  final Vehicle vehicle;

  const FormsVehicle({required this.vehicle, super.key});

  @override
  State<FormsVehicle> createState() => _FormsVehicleState();
}

class _FormsVehicleState extends State<FormsVehicle> {
  VehicleServices vehicleServices = VehicleServices();
  List<Vehicle> userVehicles = [];

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
    return FutureBuilder(
      future: vehicleServices.getVehiclesForUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          List<Vehicle> userVehicles = snapshot.data as List<Vehicle>;

          return Column(
            children: [
              for (int i = 0; i < userVehicles.length; i++)
                _buildVehicleForm(userVehicles[i], i, context),

              //verificacao para adicionar veiculo
              if (userVehicles.length < 3)
                GestureDetector(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CreateVehicleModal();
                      },
                    );
                    _loadUserVehicles();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 120,
                      right: 120,
                      top: 30,
                      bottom: 45,
                    ),
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          spreadRadius: 1,
                          color: Colors.grey,
                          blurRadius: 10,
                          offset: Offset(3, 1),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add_circle_rounded,
                            size: 48.0, color: primaryColor),
                        SizedBox(height: 8.0),
                        Text('Adicionar Veículo', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  Widget _buildVehicleForm(Vehicle vehicle, int index, BuildContext context) {
    List<Widget> vehicleForms = [
      Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 25,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  spreadRadius: 1,
                  color: Colors.grey,
                  blurRadius: 10,
                  offset: Offset(3, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                if (index > 0) const SizedBox(height: 1),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3),
                          child: TextFormField(
                            controller:
                                TextEditingController(text: vehicle.plate.text),
                            decoration: const InputDecoration(
                                labelText: "Placa", border: InputBorder.none),
                            enabled: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3),
                          child: TextFormField(
                            controller:
                                TextEditingController(text: vehicle.model.text),
                            decoration: const InputDecoration(
                                labelText: "Modelo", border: InputBorder.none),
                            enabled: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3),
                          child: TextFormField(
                            controller:
                                TextEditingController(text: vehicle.brand.text),
                            decoration: const InputDecoration(
                                labelText: "Marca", border: InputBorder.none),
                            enabled: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: TextFormField(
                            controller: TextEditingController(
                                text: vehicle.yearFabrication.text),
                            decoration: const InputDecoration(
                                labelText: "Ano", border: InputBorder.none),
                            enabled: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3),
                          child: TextFormField(
                            controller:
                                TextEditingController(text: vehicle.color.text),
                            decoration: const InputDecoration(
                                labelText: "Cor", border: InputBorder.none),
                            enabled: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3),
                          child: TextFormField(
                            controller: TextEditingController(
                                text: vehicle.gearShift.text),
                            decoration: const InputDecoration(
                                labelText: "Câmbio", border: InputBorder.none),
                            enabled: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            left: 20,
            child: IconButton(
              onPressed: () async {
                await vehicleServices.deleteVehicle(context, vehicle);
                _loadUserVehicles();
              },
              icon: const Icon(Icons.delete_forever_outlined),
            ),
          ),
          Positioned(
            top: 8,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      UpdateVehicleModal(vehicle: vehicle),
                );
                _loadUserVehicles();
              },
            ),
          ),
        ],
      ),
    ];

    return Column(children: vehicleForms);
  }
}
