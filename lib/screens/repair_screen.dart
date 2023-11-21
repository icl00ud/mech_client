import 'package:flutter/material.dart';
import 'package:mech_client/widgets/Repairs/repair_request_widget.dart';
import 'package:mech_client/services/repair_services.dart';
import 'package:mech_client/models/repair.dart';

import '../widgets/Repairs/repair_create_widget.dart';

class RepairPage extends StatefulWidget {
  const RepairPage({Key? key}) : super(key: key);

  @override
  RepairPageState createState() => RepairPageState();
}

class RepairPageState extends State<RepairPage> {
  final RepairServices repairServices = RepairServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        spreadRadius: 1,
                        color: Colors.grey,
                        blurRadius: 2,
                        offset: Offset(2, 1.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const ServiceRequestModal();
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFFF5C00),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(2),
                        ),
                        child: const Icon(Icons.add, size: 32),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Solicitar Serviço',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Serviços Aceitos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5C00),
                ),
              ),
              const Text(
                'Nenhuma solicitação aceita.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 20),
              const Text(
                'Serviços Pendentes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5C00),
                ),
              ),
              const Text(
                'Nenhuma solicitação pendente.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
