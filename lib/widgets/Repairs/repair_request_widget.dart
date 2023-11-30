import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/account_user_model.dart';
import '../../services/user_services.dart';

class RepairRequestWidget extends StatefulWidget {
  final String documentId;
  final String requestTitle;
  final String plate;
  final VoidCallback onDetailsPressed;
  final VoidCallback onDeletePressed;

  const RepairRequestWidget({
    Key? key,
    required this.documentId,
    required this.requestTitle,
    required this.plate,
    required this.onDetailsPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  _RepairRequestWidgetState createState() => _RepairRequestWidgetState();
}

class _RepairRequestWidgetState extends State<RepairRequestWidget> {
  final UserServices userServices = UserServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late String userType = '';

  @override
  void initState() {
    super.initState();
    getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            spreadRadius: 1,
            color: Colors.grey,
            blurRadius: 1,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.requestTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.plate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (userType == 'Cliente') ...[
                IconButton(
                  icon: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Confirmar Exclusão',
                            style: TextStyle(color: Color(0xFFFF5C00)),
                          ),
                          content: const Text('Deseja realmente excluir este serviço?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                widget.onDeletePressed();
                              },
                              child: const Text(
                                'Confirmar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                          backgroundColor: Colors.white,
                        );
                      },
                    );
                  },
                  color: Colors.red,
                  iconSize: 24,
                ),
              ],
              const SizedBox(width: 2),
              ElevatedButton(
                onPressed: () {
                  widget.onDetailsPressed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5C00),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Detalhes',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getUserType() async {
    AccountUser? user = await userServices.getUserByUid(_firebaseAuth.currentUser!.uid);

    if (user != null) {
      setState(() {
        userType = user.type;
      });
    }
  }
}