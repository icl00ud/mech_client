import 'package:flutter/material.dart';
import 'package:mech_client/models/mechanic.dart';
import 'package:mech_client/services/feedback_utils.dart';
import 'package:mech_client/services/user_services.dart';
import '../models/client.dart';

class ValidationUser {
  static bool checkBoxValue = false;
  UserServices userServices = UserServices();
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    bool isValid = emailRegex.hasMatch(email);

    return isValid;
  }

  static bool isValidCPF(String value) {
    if (value.isEmpty) return false;

    // remove caracteres não numéricos
    value = value.replaceAll(RegExp(r'\D'), '');

    if (value.length != 11) return false;

    // verifica se todos os digitos são iguais o que é inválido
    if (RegExp(r'(\d)\1{10}').hasMatch(value)) return false;

    // calculo do primeiro digito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(value[i]) * (10 - i);
    }
    int firstDigit = 11 - (sum % 11);

    // calculo do segundo digito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(value[i]) * (11 - i);
    }
    int secondDigit = 11 - (sum % 11);

    if (firstDigit == 10) firstDigit = 0;
    if (secondDigit == 10) secondDigit = 0;

    return int.parse(value[9]) == firstDigit &&
        int.parse(value[10]) == secondDigit;
  }

  static bool isValidPhone(String phone) {
    // remove caracteres nao numéricos
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');

    return cleanPhone.length == 11;
  }

  static bool isValidCEP(String cep) {
    // Remove caracteres não numéricos
    final cleanCEP = cep.replaceAll(RegExp(r'\D'), '');

    return cleanCEP.length == 8;
  }

  static bool isValidCNPJ(String cnpj) {
    // remova caracteres nao numéricos do CNPJ
    cnpj = cnpj.replaceAll(RegExp(r'\D'), '');

    // deve ter 14 dígitos
    if (cnpj.length != 14) {
      return false;
    }

    if (RegExp(r'^(\d)\1+$').hasMatch(cnpj)) {
      return false;
    }

    // calculo do primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += int.parse(cnpj[i]) * (5 - i);
    }
    int digit1 = 11 - (sum % 11);
    if (digit1 >= 10) {
      digit1 = 0;
    }
    if (int.parse(cnpj[12]) != digit1) {
      return false;
    }

    // calculo do segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 13; i++) {
      sum += int.parse(cnpj[i]) * (6 - i);
    }
    int digit2 = 11 - (sum % 11);
    if (digit2 >= 10) {
      digit2 = 0;
    }
    return int.parse(cnpj[13]) == digit2;
  }

  static bool validationClientFields(BuildContext context, Client client) {
    // lista para verificar os campos vazios
    List<TextEditingController> register = [
      client.name,
      client.cpf,
      client.phone,
      client.email,
      client.address.address,
      client.address.number,
      client.address.zip,
      client.password,
      client.confirmPassword,
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

    // validaçoes \\
    if (!empty && !isValidCPF(client.cpf.text)) {
      FeedbackUtils.showErrorSnackBar(context, 'CPF inválido');
      return false;
    }

    if (!empty && !isValidPhone(client.phone.text)) {
      FeedbackUtils.showErrorSnackBar(
          context, 'Telefone deve conter 11 dígitos.');
      return false;
    }

    if (!empty && !isValidEmail(client.email.text)) {
      FeedbackUtils.showErrorSnackBar(
          context, 'O e-mail inserido não é válido.');
      return false;
    }

    if (!empty && !isValidCEP(client.address.zip.text)) {
      FeedbackUtils.showErrorSnackBar(context, 'O CEP deve conter 8 dígitos.');
      return false;
    }

    if (!empty && client.password.text != client.confirmPassword.text) {
      FeedbackUtils.showErrorSnackBar(
          context, 'As senhas não coincidem. Por favor, tente novamente.');
      return false;
    }

    if (!empty && !checkBoxValue) {
      FeedbackUtils.showErrorSnackBar(context, 'Aceite os termos e políticas.');
      return false;
    }

    return !empty;
  }

  static bool validationMechanicFields(
      BuildContext context, Mechanic mechanic) {
    // lista para verificar os campos vazios
    List<TextEditingController> register = [
      mechanic.name,
      mechanic.cnpj,
      mechanic.phone,
      mechanic.email,
      mechanic.address.address,
      mechanic.address.number,
      mechanic.address.zip,
      mechanic.password,
      mechanic.confirmPassword,
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

    // validaçoes \\
    if (!empty && !isValidCNPJ(mechanic.cnpj.text)) {
      FeedbackUtils.showErrorSnackBar(context, 'CNPJ inválido');
      return false;
    }

    if (!empty && !isValidPhone(mechanic.phone.text)) {
      FeedbackUtils.showErrorSnackBar(
          context, 'Telefone deve conter 11 dígitos.');
      return false;
    }

    if (!empty && !isValidEmail(mechanic.email.text)) {
      FeedbackUtils.showErrorSnackBar(
          context, 'O e-mail inserido não é válido.');
      return false;
    }

    if (!empty && !isValidCEP(mechanic.address.zip.text)) {
      FeedbackUtils.showErrorSnackBar(context, 'O CEP deve conter 8 dígitos.');
      return false;
    }

    if (!empty && mechanic.password.text != mechanic.confirmPassword.text) {
      FeedbackUtils.showErrorSnackBar(
          context, 'As senhas não coincidem. Por favor, tente novamente.');
      return false;
    }

    if (!empty && !checkBoxValue) {
      FeedbackUtils.showErrorSnackBar(context, 'Aceite os termos e políticas.');
      return false;
    }

    return !empty;
  }

  static bool validationLogin(
    BuildContext context,
    Client client,
  ) {
    if (client.email.text.isEmpty || client.password.text.isEmpty) {
      FeedbackUtils.showErrorSnackBar(
          context, 'Preencha todos os campos obrigatórios.');
      return false;
    }
    if (!ValidationUser.isValidEmail(client.email.text)) {
      FeedbackUtils.showErrorSnackBar(context, 'Email inválido.');
      return false;
    }
    return true;
  }
}
