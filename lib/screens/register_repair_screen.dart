import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:mech_client/screens/repair_screen.dart';
import 'package:mech_client/services/user_services.dart';
import 'package:mech_client/services/validationUser.dart';

class RegisterRepairPage extends StatefulWidget {
  const RegisterRepairPage({Key? key}) : super(key: key);

  @override
  RegisterRepairPageState createState() => RegisterRepairPageState();
}

class RegisterRepairPageState extends State<RegisterRepairPage> {
  static double padding = 3;

  ValidationUser validation = ValidationUser();
  UserServices userServices = UserServices();

  //final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.build,
                size: 50,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Conserto",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFFF5C00),
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
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
                            child: DateTimePicker(
                              readOnly: true,
                              dateMask: 'dd/MM/yyyy',
                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                              decoration:
                                  const InputDecoration(labelText: "Data"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      maxLines:
                          null, // ou um número grande, por exemplo, maxLines: 10,
                      decoration: const InputDecoration(
                        labelText: "Problema Relatado",
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const RepairPage()),
                            );
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
    ),
    );
  }
}