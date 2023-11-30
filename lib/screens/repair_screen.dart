import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mech_client/services/user_services.dart';
import 'package:mech_client/utils/constans_utils.dart';
import 'package:mech_client/utils/feedback_utils.dart';
import '../models/account_user_model.dart';
import '../models/repair/repair_details.dart';
import '../services/repair_services.dart';
import '../widgets/Repairs/repair_create_widget.dart';
import '../widgets/Repairs/repair_details_widget.dart';
import '../widgets/Repairs/repair_request_widget.dart';

class RepairPage extends StatefulWidget {
  const RepairPage({Key? key}) : super(key: key);

  @override
  RepairPageState createState() => RepairPageState();
}

class RepairPageState extends State<RepairPage> {
  final RepairServices repairServices = RepairServices();
  final UserServices userServices = UserServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<Map<String, dynamic>> acceptedRequests = [];
  List<Map<String, dynamic>> pendingRequests = [];

  bool loading = false;
  late String userType = '';

  StreamSubscription<List<Map<String, dynamic>>>? acceptedSubscription;
  StreamSubscription<List<Map<String, dynamic>>>? pendingSubscription;

  var userId = UserServices().getUserId().toString();

  List<String> plates = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getUserType();
    await loadRepairRequests();
    fetchPlates();
  }

  Future<void> fetchPlates() async {
    try {
      List<String> userPlates = await repairServices.getPlates(userId);
      setState(() {
        plates = userPlates;
      });
    } catch (e) {
      print('Erro ao obter placas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(4),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (userType == 'Cliente') ...[
                  Container(
                    padding: const EdgeInsets.only(bottom: 24, top: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 3,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (plates.isEmpty) {
                                FeedbackUtils.showErrorSnackBar(context,
                                    "Antes de solicitar um serviço cadastre seu veículo.");
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const ServiceRequestModal(),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF5C00),
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(2),
                            ),
                            child: const Icon(Icons.add, size: 32),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Solicitar Serviço',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
                const Text(
                  'Serviços Aceitos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5C00),
                  ),
                ),
                const SizedBox(height: 10),
                if (loading) ...[
                  const CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ] else if (acceptedRequests.isNotEmpty)
                  Column(
                    children: acceptedRequests.map((request) {
                      final details = RepairDetails(
                          title: request['title'] ?? '',
                          description: request['description'] ?? '',
                          creationDate: (request['dt_creation'] as Timestamp)
                              .toDate()
                              .toString(),
                          assignedMechanic:
                              request['assigned_mechanic_id'] ?? '',
                          status: request['status'] == 'accepted'
                              ? 'Aceito'
                              : 'Pendente',
                          carModel: request['model'] ?? '',
                          plate: request['plate'] ?? '',
                          documentId: request['id'],
                          customerPhone: request['customer']['phone']);

                      final String documentId = request['id'];

                      return RepairRequestWidget(
                        documentId: details.documentId,
                        requestTitle: details.title,
                        plate: details.plate,
                        onDetailsPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DetailsModal(
                                  details: details,
                                  userType: userType,
                                  repairId: documentId);
                            },
                          );
                        },
                        onDeletePressed: () async {
                          String repairId = request['id'];
                          await deleteRepair(repairId);
                          await loadRepairRequests();
                        },
                      );
                    }).toList(),
                  )
                else
                  const Text(
                    'Nenhuma solicitação aceita',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 15),
                Text(
                  userType == 'Cliente'
                      ? 'Serviços Pendentes'
                      : 'Serviços Disponíveis',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5C00),
                  ),
                ),
                const SizedBox(height: 10),
                if (loading) ...[
                  const CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ] else if (pendingRequests.isNotEmpty)
                  Column(
                    children: pendingRequests.map((request) {
                      final details = RepairDetails(
                          title: request['title'] ?? '',
                          description: request['description'] ?? '',
                          creationDate: (request['dt_creation'] as Timestamp)
                              .toDate()
                              .toString(),
                          assignedMechanic: request['assigned_mechanic_id'] ??
                              'Aguardando ser aceito por alguma mecânica',
                          status: request['status'] == 'pending'
                              ? 'Pendente'
                              : 'Aceito',
                          carModel: request['model'] ?? '',
                          plate: request['plate'] ?? '',
                          documentId: request['id'],
                          customerPhone: request['customer']['phone']);

                      final String documentId = request['id'];

                      return RepairRequestWidget(
                        documentId: details.documentId,
                        requestTitle: details.title,
                        plate: details.plate,
                        onDetailsPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DetailsModal(
                                  details: details,
                                  userType: userType,
                                  repairId: documentId);
                            },
                          );
                        },
                        onDeletePressed: () async {
                          String repairId = request['id'];
                          await deleteRepair(repairId);
                          await loadRepairRequests();
                        },
                      );
                    }).toList(),
                  )
                else
                  const Text(
                    'Nenhuma solicitação pendente',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadRepairRequests() async {
    setState(() {
      loading = true;
    });

    acceptedSubscription?.cancel();
    if (userType == 'Cliente') {
      acceptedSubscription = repairServices
          .getAcceptedRequestsForCustomer()
          .listen((List<Map<String, dynamic>> data) {
        setState(() {
          acceptedRequests = data;
        });
      });

      pendingSubscription?.cancel();
      pendingSubscription = repairServices
          .getPendingRequestsForCustomer()
          .listen((List<Map<String, dynamic>> data) {
        setState(() {
          pendingRequests = data;
        });
      });
    } else {
      acceptedSubscription = repairServices
          .getAcceptedRequestsForMechanic()
          .listen((List<Map<String, dynamic>> data) {
        setState(() {
          acceptedRequests = data;
        });
      });

      pendingSubscription?.cancel();
      pendingSubscription = repairServices
          .getPendingRequestsForMechanic()
          .listen((List<Map<String, dynamic>> data) {
        setState(() {
          pendingRequests = data;
        });
      });
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> deleteRepair(String repairId) async {
    setState(() {
      loading = true;
    });

    try {
      await repairServices.deleteRepair(repairId);
      await loadRepairRequests();
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> getUserType() async {
    AccountUser? user =
        await userServices.getUserByUid(_firebaseAuth.currentUser!.uid);

    if (user != null) {
      setState(() {
        userType = user.type;
      });
    }
  }
}
