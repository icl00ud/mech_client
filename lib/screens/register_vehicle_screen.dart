import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mech_client/models/vehicle_model.dart';
import 'package:mech_client/services/validation_user_service.dart';
import 'package:mech_client/services/vehicle_services.dart';
import 'package:mech_client/utils/constans_utils.dart';
import 'package:mech_client/widgets/button_widget.dart';

class RegisterVehiclePage extends StatefulWidget {
  const RegisterVehiclePage({Key? key}) : super(key: key);

  @override
  RegisterVehiclePageState createState() => RegisterVehiclePageState();
}

class RegisterVehiclePageState extends State<RegisterVehiclePage> {
  static double padding = 3;

  ValidationUser validation = ValidationUser();
  Vehicle vehicle = Vehicle();
  VehicleServices vehicleServices = VehicleServices();

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
              Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 20),
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
                              controller: vehicle.plate,
                              decoration:
                                  const InputDecoration(labelText: "Placa"),
                              onChanged: (value) {
                                vehicle.plate.value =
                                    vehicle.plate.value.copyWith(
                                  text: value.toUpperCase(),
                                  selection: TextSelection.collapsed(
                                      offset: value.length),
                                );
                              },
                              inputFormatters: [
                                MaskTextInputFormatter(
                                  mask: 'AAA-9999',
                                  filter: {
                                    '9': RegExp(r'[0-9]'),
                                    'A': RegExp(r'[a-zA-Z]')
                                  },
                                ),
                              ],
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
                              controller: vehicle.model,
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
                              controller: vehicle.brand,
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
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [
                                MaskTextInputFormatter(
                                    mask: '####',
                                    filter: {'#': RegExp(r'[0-9]')})
                              ],
                              controller: vehicle.yearFabrication,
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
                              controller: vehicle.color,
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
                              controller: vehicle.gearShift,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Button(
                            text: "Cadastrar",
                            function: () {
                              vehicleServices.registerVehicle(vehicle, context);
                            }),
                        Button(
                          text: "Cancelar",
                          function: () {
                            Navigator.of(context).pop();
                          },
                        )
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
