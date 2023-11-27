import 'package:flutter/material.dart';

class RepairRequestWidget extends StatelessWidget {
  final String requestTitle;
  final String plate;
  final VoidCallback onDetailsPressed;
  final VoidCallback onDeletePressed;

  const RepairRequestWidget({
    Key? key,
    required this.requestTitle,
    required this.plate,
    required this.onDetailsPressed,
    required this.onDeletePressed,
  }) : super(key: key);

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
                  requestTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  plate,
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
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmar Exclusão',
                        style: TextStyle(
                          color: Color(0xFFFF5C00))
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
                              onDeletePressed();
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
              const SizedBox(width: 2),
              ElevatedButton(
                onPressed: onDetailsPressed,
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFFF5C00),
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
}
