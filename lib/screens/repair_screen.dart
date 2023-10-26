import 'package:flutter/material.dart';
import 'package:mech_client/screens/register_repair_screen.dart';
import 'package:mech_client/services/repair_services.dart';
import 'package:mech_client/models/repair.dart';

class RepairPage extends StatelessWidget {
  const RepairPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: RegisterRepair(),
        ),
      ),
    );
  }
}

class RegisterRepair extends StatefulWidget {
  const RegisterRepair({Key? key}) : super(key: key);

  @override
  _RegisterRepairState createState() => _RegisterRepairState();
}

class _RegisterRepairState extends State<RegisterRepair> {
  //List<String> repairs = []; // Lista de veículos do usuário
  static double padding = 3;
  Repair repair = Repair();
  RepairServices repairServices = RepairServices();

  @override
  void initState() {
    repairServices.getRepair(repair);

    super.initState();
  }

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
                              controller: repair.plate,
                              decoration:
                                  const InputDecoration(labelText: "Placa"),
                              enabled: false,
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
                              controller: repair.date,
                              decoration:
                                  const InputDecoration(labelText: "Data"),
                              enabled: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: repair.description,
                      maxLines:
                          null, // ou um número grande, por exemplo, maxLines: 10,
                      decoration: const InputDecoration(
                        labelText: "Problema Relatado",
                        enabled: false,
                      ),
                    ),
                  ],
                ),
              ),
              // Add another card below this one
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const RegisterRepairPage()),
                  );
                  // Coloque a ação que você deseja realizar ao tocar no card aqui
                },
                child: Container(
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add_circle_rounded,
                          size: 48.0, color: Color(0xFFFF5C00)),
                      SizedBox(height: 8.0),
                      Text('Relatar Problema', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
