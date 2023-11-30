import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mech_client/utils/constans_utils.dart';

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
      padding: const EdgeInsets.only(right: 12, top: 12, bottom: 12, left: 8),
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
          if (userType == 'Cliente') ...[
            IconButton(
              icon: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(20),
                      icon: const Icon(
                        Icons.warning_amber_outlined,
                        size: 30,
                      ),
                      title: const Text(
                        'Confirmar Exclusão',
                        style: TextStyle(color: Colors.black),
                      ),
                      content:
                          const Text('Deseja realmente excluir este serviço?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onDeletePressed();
                          },
                          child: const Text(
                            'Confirmar',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                      backgroundColor: Colors.white,
                    );
                  },
                );
              },
            ),
            Container(
              padding: EdgeInsets.zero,
              color: const Color.fromARGB(255, 205, 205, 205),
              width: 1,
              height: 50, // Altura desejada da linha
              margin: const EdgeInsets.symmetric(
                  horizontal: 8), // Adicione um recuo horizontal se necessário
            ),
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
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
          ),
          Row(
            children: [
              const SizedBox(width: 2),
              ElevatedButton(
                onPressed: () {
                  widget.onDetailsPressed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5C00),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
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
    AccountUser? user =
        await userServices.getUserByUid(_firebaseAuth.currentUser!.uid);

    if (user != null) {
      setState(() {
        userType = user.type;
      });
    }
  }
}
