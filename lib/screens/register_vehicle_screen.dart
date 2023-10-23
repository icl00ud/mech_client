import 'package:flutter/material.dart';
import 'package:mech_client/models/client.dart';
import 'package:mech_client/models/mechanic.dart';
import 'package:mech_client/services/validationUser.dart';

class RegisterVehiclePage extends StatefulWidget {
  const RegisterVehiclePage({Key? key}) : super(key: key);

  @override
  RegisterVehiclePageState createState() => RegisterVehiclePageState();
}

class RegisterVehiclePageState extends State<RegisterVehiclePage> {
  static double padding = 3;

  Mechanic mechanic = Mechanic();
  Client client = Client();
  ValidationUser validation = ValidationUser();

  final _formkey = GlobalKey<FormState>();

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
                        color: Color(0xFFFF5C00)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 30, top: 5, bottom: 20),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        spreadRadius: 1,
                        color: Colors.grey,
                        blurRadius: 10,
                        offset: Offset(3, 1)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: padding, bottom: padding),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Placa"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: padding, bottom: padding),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Modelo"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: padding, bottom: padding),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Marca"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: padding, bottom: padding),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Ano"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: padding, bottom: padding),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Cor"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: padding, bottom: padding),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Câmbio"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Logic for "Cadastrar" button
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5C00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          child: const Text(
                            'Cadastrar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Logic for "Cancelar" button
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5C00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
