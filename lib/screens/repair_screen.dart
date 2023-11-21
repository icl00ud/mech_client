import 'package:flutter/material.dart';
import '../services/repair_services.dart';
import '../widgets/Repairs/repair_create_widget.dart';
import '../widgets/Repairs/repair_request_widget.dart';

class RepairPage extends StatefulWidget {
  const RepairPage({Key? key}) : super(key: key);

  @override
  RepairPageState createState() => RepairPageState();
}

class RepairPageState extends State<RepairPage> {
  final RepairServices repairServices = RepairServices();

  List<Map<String, dynamic>> acceptedRequests = [];
  List<Map<String, dynamic>> pendingRequests = [];

  @override
  void initState() {
    super.initState();
    loadRepairRequests();
  }

  Future<void> loadRepairRequests() async {
    repairServices.getAcceptedRequests().listen((List<Map<String, dynamic>> data) {
      setState(() {
        acceptedRequests = data;
      });
    });

    repairServices.getPendingRequests().listen((List<Map<String, dynamic>> data) {
      setState(() {
        pendingRequests = data;
      });
    });
  }

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

              // Container para centralizar os elementos
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(2, 1.5),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ServiceRequestModal(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFFF5C00),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
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

              // Serviços Aceitos
              const Text(
                'Serviços Aceitos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5C00),
                ),
              ),
              if (acceptedRequests.isNotEmpty)
                Column(
                  children: acceptedRequests.map((request) {
                    return RepairRequestWidget(
                      requestTitle: request['title'] ?? '',
                      requestDetails: request['details'] ?? '',
                    );
                  }).toList(),
                )
              else
                const Text(
                  'Nenhuma solicitação aceita.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 15),
              const SizedBox(height: 20),

              // Serviços Pendentes
              const Text(
                'Serviços Pendentes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5C00),
                ),
              ),
              if (pendingRequests.isNotEmpty)
                Column(
                  children: pendingRequests.map((request) {
                    return RepairRequestWidget(
                      requestTitle: request['title'] ?? '',
                      requestDetails: request['details'] ?? '',
                    );
                  }).toList(),
                )
              else
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