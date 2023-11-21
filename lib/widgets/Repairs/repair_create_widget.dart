import 'package:flutter/material.dart';
import '../../services/repair_services.dart';

class ServiceRequestModal extends StatefulWidget {
  const ServiceRequestModal({Key? key}) : super(key: key);

  @override
  _ServiceRequestModalState createState() => _ServiceRequestModalState();
}

class _ServiceRequestModalState extends State<ServiceRequestModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController plateController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController motorController = TextEditingController();

  final RepairServices repairServices = RepairServices();

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
                'Solicitar Serviço',
                style: TextStyle(
                  color: Color(0xFFFF5C00),
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 0),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição do Problema'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextField(
                        controller: plateController,
                        decoration: const InputDecoration(labelText: 'Placa do carro'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextField(
                        controller: modelController,
                        decoration: const InputDecoration(labelText: 'Modelo'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextField(
                        controller: yearController,
                        decoration: const InputDecoration(labelText: 'Ano'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextField(
                        controller: motorController,
                        decoration: const InputDecoration(labelText: 'Motor'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String title = titleController.text;
                  String description = descriptionController.text;
                  String plate = plateController.text;
                  String model = modelController.text;
                  String year = yearController.text;
                  String motor = motorController.text;

                  repairServices.createRepair(
                    title: title,
                    description: description,
                    plate: plate,
                    model: model,
                    year: year,
                    motor: motor,
                  );

                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFFF5C00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: const Text('Salvar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}