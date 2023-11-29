import 'package:flutter/widgets.dart';
import 'package:mech_client/models/vehicle_model.dart';
import 'package:mech_client/utils/feedback_utils.dart';

class VehicleValidation {
  static bool isValidYear(String year) {
    int? yearValue = int.tryParse(year);
    int currentYear = DateTime.now().year;

    return yearValue != null && yearValue <= currentYear;
  }

  static bool validationFieldsVehicle(BuildContext context, Vehicle vehicle) {
    List<TextEditingController> register = [
      vehicle.model,
      vehicle.brand,
      vehicle.color,
      vehicle.gearShift,
      vehicle.plate,
      vehicle.yearFabrication
    ];

    bool empty = false;

    for (TextEditingController controller in register) {
      if (controller.text.isEmpty) {
        empty = true;
        FeedbackUtils.showErrorSnackBar(
            context, 'Preencha todos os campos obrigatórios.');
        break;
      }
    }

    if (!empty && vehicle.plate.text.length != 8) {
      FeedbackUtils.showErrorSnackBar(
          context, "Por favor, insira uma placa válida com 7 dígitos.");
      return false;
    }
    if (!empty &&
        (vehicle.yearFabrication.text.length != 4 ||
            !RegExp(r'^[0-9]+$').hasMatch(vehicle.yearFabrication.text))) {
      FeedbackUtils.showErrorSnackBar(context,
          "Por favor, insira um ano de fabricação válido com 4 dígitos.");
      return false;
    } else if (!empty && !isValidYear(vehicle.yearFabrication.text)) {
      FeedbackUtils.showErrorSnackBar(context,
          "Por favor, insira um ano de fabricação que não seja maior que o ano atual.");
      return false;
    }

    return !empty;
  }
}
