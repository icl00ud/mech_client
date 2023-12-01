import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mech_client/utils/constans_utils.dart';
import '../../models/repair/repair_details.dart';
import '../../services/repair_services.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsModal extends StatelessWidget {
  final RepairDetails details;
  final String userType;
  final String repairId;

  const DetailsModal({
    Key? key,
    required this.details,
    required this.userType,
    required this.repairId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              buildInputField(
                  'Data de Criação', formatDate(details.creationDate)),
              buildInputField('Mecânica Responsável', details.assignedMechanic),
              buildInputField('Status', details.status),
              buildInputField('Modelo do Carro', details.carModel),
              userType == 'Cliente'
                  ? buildInputField('Placa', details.plate)
                  : buildInputField('Telefone', details.customerPhone),
              const SizedBox(height: 18.0),
              if (userType != 'Cliente')
                details.status == 'Aceito'
                    ? buildWhatsAppButton()
                    : buildAcceptButton(context, repairId),
              SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, String value) {
    final repairServices = RepairServices();

    return userType != 'Cliente' && label == 'Placa'
        ? const SizedBox()
        : Padding(
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
                FutureBuilder<String>(
                  future: _buildInputFieldValue(label, value, repairServices),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: primaryColor,
                      );
                    } else if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    } else {
                      return Text(
                        snapshot.data ?? '',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
  }

  Future<String> _buildInputFieldValue(
      String label, String value, RepairServices repairServices) async {
    if (label == 'Mecânica Responsável') {
      return await repairServices.getMechanicName(details.assignedMechanic);
    } else {
      return value;
    }
  }

  Widget buildAcceptButton(BuildContext context, String repairId) {
    final repairServices = RepairServices();

    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          showAcceptConfirmationDialog(context, repairServices, repairId);
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
    );
  }

  Widget buildWhatsAppButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        onPressed: () {
          launchWhatsApp();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        icon: const Icon(FontAwesomeIcons.whatsapp),
        label: const Text(
          'WhatsApp',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Future<void> showAcceptConfirmationDialog(BuildContext context,
      RepairServices repairServices, String repairId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle_outline,
            size: 30,
          ),
          title: const Text('Confirmar', style: TextStyle()),
          content: const Text('Deseja realmente aceitar este serviço?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar',
                  style: TextStyle(
                    color: Colors.black,
                  )),
            ),
            TextButton(
              onPressed: () async {
                await repairServices.confirmRepairAssignment(repairId);
              },
              child: const Text(
                'Confirmar',
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formattedDate =
        DateFormat('dd/MM/yyyy \'às\' HH:mm').format(dateTime);
    return formattedDate;
  }

  launchWhatsApp() async {
    final repairServices = RepairServices();

    var mechanicName =
        await repairServices.getMechanicName(details.assignedMechanic);
    final phoneNumber = details.customerPhone.replaceAll(RegExp(r'[^\d]'), '');
    final message =
        'Olá! Somos da empresa *$mechanicName*. Estamos entrando em contato referente ao seu chamado *${details.title}*.';

    final Uri url = Uri.parse(
        'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}');

    try {
      await launchUrl(url);
    } catch (error) {
      print(error);
    }
  }
}
