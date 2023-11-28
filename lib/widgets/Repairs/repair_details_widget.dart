import 'package:flutter/material.dart';
import '../../models/repair/repair_details.dart';
import '../../services/repair_services.dart'; // Importe o serviço aqui

class DetailsModal extends StatelessWidget {
  final RepairDetails details;
  final String userType;

  late String repairId = ''; // Adicione esta linha

  DetailsModal({
    Key? key,
    required this.details,
    required this.userType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repairServices = RepairServices(); // Instancie o serviço aqui

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detalhes do chamado',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF5C00),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              buildInputField('Descrição', details.description),
              buildInputField('Data de Criação', details.creationDate),
              buildInputField('Mecânica Responsável', details.assignedMechanic),
              buildInputField('Status', details.status),
              buildInputField('Modelo do Carro', details.carModel),
              buildInputField('Placa', details.plate),
              const SizedBox(height: 12.0),
              if (userType != 'Cliente')
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      showAcceptConfirmationDialog(context, repairServices);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5C00),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Aceitar',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showAcceptConfirmationDialog(BuildContext context, RepairServices repairServices) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar',
              style: TextStyle(
                color: Color(0xFFFF5C00),
              )
          ),
          content: const Text('Deseja realmente aceitar este serviço?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar',
                  style: TextStyle(
                    color: Colors.black,
                  )
              ),
            ),
            TextButton(
              onPressed: () async {
                await repairServices.confirmRepairAssignment(repairId);
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar',
                style: TextStyle(
                  color: Color(0xFFFF5C00),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}