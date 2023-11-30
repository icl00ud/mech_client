import 'package:flutter/material.dart';
import 'package:mech_client/services/user_services.dart';
import 'package:mech_client/services/vehicle_services.dart';
import 'package:mech_client/utils/constans_utils.dart';
import 'package:mech_client/utils/feedback_utils.dart';
import '../../services/repair_services.dart';

class ServiceRequestModal extends StatefulWidget {
  const ServiceRequestModal({Key? key}) : super(key: key);

  @override
  _ServiceRequestModalState createState() => _ServiceRequestModalState();
}

class _ServiceRequestModalState extends State<ServiceRequestModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController brandController = TextEditingController();

  final RepairServices repairServices = RepairServices();

  var userId = UserServices().getUserId().toString();
  String selectedPlate = '';

  List<String> plates = [];

  @override
  void initState() {
    super.initState();
    fetchPlates();
    print("ID: $userId");
  }

  Future<void> fetchPlates() async {
    try {
      List<String> userPlates = await repairServices.getPlates(userId);
      setState(() {
        plates = userPlates;
      });
    } catch (e) {
      // Lidar com erros
      print('Erro ao obter placas: $e');
    }
  }

  Future<void> updateFields(String selectedPlate) async {
    try {
      Map<String, dynamic>? vehicleData =
          await VehicleServices().getVehicleByPlate(selectedPlate);

      if (vehicleData != null) {
        setState(() {
          modelController.text = vehicleData['model'] ?? '';
          yearController.text = vehicleData['yearFabrication'] ?? '';
          brandController.text = vehicleData['brand'] ??
              ''; // Adicione o campo correto aqui, dependendo do nome do campo em seu mapa
        });
      }
    } catch (e) {
      // Lidar com erros
      print('Erro ao atualizar campos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Solicitar Serviço',
                style: TextStyle(
                  color: Color(0xFFFF5C00),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Descrição do Problema'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: DropdownButton<String>(
                        items: plates.map((String plate) {
                          return DropdownMenuItem<String>(
                            value: plate,
                            child: Text(plate),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              updateFields(value);
                              selectedPlate = value;
                            });
                          }
                        },
                        hint:
                            Text(selectedPlate == '' ? 'Placa' : selectedPlate),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextField(
                        controller: modelController,
                        decoration: const InputDecoration(labelText: 'Modelo'),
                        enabled: false,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextField(
                        controller: yearController,
                        decoration: const InputDecoration(labelText: 'Ano'),
                        enabled: false,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextField(
                        controller: brandController,
                        decoration: const InputDecoration(labelText: 'Marca'),
                        enabled: false,
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
                  String plate = plates.isNotEmpty ? plates.first : "";
                  String model = modelController.text;
                  String year = yearController.text;
                  String brand = brandController.text;

                  if (title.isEmpty || description.isEmpty) {
                    FeedbackUtils.showErrorSnackBar(
                        context, "Por favor, preencha todos os campos.");
                  } else {
                    repairServices.createRepair(
                      title: title,
                      description: description,
                      plate: plate,
                      model: model,
                      year: year,
                      motor: brand,
                    );

                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5C00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: const Text('Solicitar', style: TextStyle(fontSize: 16)),
              ),
              TextButton(
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
