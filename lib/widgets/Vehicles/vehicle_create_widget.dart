import 'package:flutter/material.dart';
import 'package:mech_client/services/validations/vehicle_validation.dart';
import 'package:mech_client/services/vehicle_services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mech_client/models/vehicle_model.dart';
import 'package:mech_client/utils/constans_utils.dart';
import 'package:mech_client/widgets/button_widget.dart';

class CreateVehicleModal extends StatefulWidget {
  const CreateVehicleModal({Key? key}) : super(key: key);

  @override
  _CreateVehicleModalState createState() => _CreateVehicleModalState();
}

class _CreateVehicleModalState extends State<CreateVehicleModal> {
  static double padding = 3;
  Vehicle vehicle = Vehicle();
  VehicleServices vehicleServices = VehicleServices();
  bool isSwitchOn = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Cadastrar Veículo',
                style: TextStyle(
                  color: Color(0xFFFF5C00),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isSwitchOn
                        ? 'Placa Mercosul (Ativada)'
                        : "Placa Mercosul (Desativada)",
                  ),
                  Switch(
                    value: isSwitchOn,
                    onChanged: (value) {
                      setState(() {
                        isSwitchOn = value;
                        if (isSwitchOn) {
                          vehicle.plate.clear();
                        }
                      });
                    },
                    activeColor: primaryColor,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(top: padding, bottom: padding),
                      child: TextFormField(
                        controller: vehicle.plate,
                        decoration: const InputDecoration(labelText: "Placa"),
                        onChanged: (value) {
                          vehicle.plate.value = vehicle.plate.value.copyWith(
                            text: value.toUpperCase(),
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        },
                        inputFormatters: [
                          isSwitchOn
                              ? MaskTextInputFormatter(
                                  mask: 'AAA-9A99',
                                  filter: {
                                    '9': RegExp(r'[0-9]'),
                                    'A': RegExp(r'[a-zA-Z]')
                                  },
                                )
                              : MaskTextInputFormatter(
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
                      padding: EdgeInsets.only(top: padding, bottom: padding),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Modelo"),
                        controller: vehicle.model,
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
                      padding: EdgeInsets.only(top: padding, bottom: padding),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Marca"),
                        controller: vehicle.brand,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(top: padding, bottom: padding),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Ano"),
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '####',
                            filter: {'#': RegExp(r'[0-9]')},
                          ),
                        ],
                        controller: vehicle.yearFabrication,
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
                      padding: EdgeInsets.only(top: padding, bottom: padding),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Cor"),
                        controller: vehicle.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(top: padding, bottom: padding),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Câmbio"),
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
                      if (VehicleValidation.validationFieldsVehicle(
                          context, vehicle)) {
                        // Se os campos são válidos, prosseguir com o cadastro
                        vehicleServices.registerVehicle(vehicle, context);
                      }
                    },
                  ),
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
      ),
    );
  }
}
