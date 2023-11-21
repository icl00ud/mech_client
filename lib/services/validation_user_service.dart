import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:mech_client/models/account_user_model.dart';
import 'package:mech_client/utils/feedback_utils.dart';
import 'package:mech_client/services/user_services.dart';

class ValidationUser {
  static bool checkBoxValue = false;
  UserServices userServices = UserServices();
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    bool isValid = emailRegex.hasMatch(email);

    return isValid;
  }

  static bool isCPFValid(String cpf) {
    return CPFValidator.isValid(cpf);
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
    return CNPJValidator.isValid(cnpj);
  }

  static bool validationFieldsUser(
      BuildContext context, AccountUser accountUser, String? select,
      {bool validateCheckbox = true}) {
    List<TextEditingController> register = [
      accountUser.name,
      if (select == "Cliente") accountUser.cpf else accountUser.cnpj,
      accountUser.phone,
      accountUser.email,
      accountUser.address.address,
      accountUser.address.number,
      accountUser.address.zip,
      accountUser.password,
      accountUser.confirmPassword,
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

    if (select == "Cliente" && !empty && !isCPFValid(accountUser.cpf.text)) {
      FeedbackUtils.showErrorSnackBar(context, 'CPF inválido.');
      return false;
    } else if (select == "Mecânica" &&
        !empty &&
        !isValidCNPJ(accountUser.cnpj.text)) {
      FeedbackUtils.showErrorSnackBar(context, 'CNPJ inválido.');
      return false;
    }

    if (!empty && !isValidPhone(accountUser.phone.text)) {
      FeedbackUtils.showErrorSnackBar(
          context, 'Telefone deve conter 11 dígitos.');
      return false;
    }

    if (!empty && !isValidEmail(accountUser.email.text)) {
      FeedbackUtils.showErrorSnackBar(
          context, 'O e-mail inserido não é válido.');
      return false;
    }

    if (!empty && !isValidCEP(accountUser.address.zip.text)) {
      FeedbackUtils.showErrorSnackBar(context, 'O CEP deve conter 8 dígitos.');
      return false;
    }

    if (!empty &&
        accountUser.password.text != accountUser.confirmPassword.text) {
      FeedbackUtils.showErrorSnackBar(
          context, 'As senhas não coincidem. Por favor, tente novamente.');
      return false;
    }

    if (validateCheckbox && !empty && !checkBoxValue) {
      FeedbackUtils.showErrorSnackBar(context, 'Aceite os termos e políticas.');
      return false;
    }

    return !empty;
  }

  static bool validationLogin(
    BuildContext context,
    AccountUser accountUser,
  ) {
    if (accountUser.email.text.isEmpty || accountUser.password.text.isEmpty) {
      FeedbackUtils.showErrorSnackBar(
          context, 'Preencha todos os campos obrigatórios.');
      return false;
    }
    if (!ValidationUser.isValidEmail(accountUser.email.text)) {
      FeedbackUtils.showErrorSnackBar(context, 'Email inválido.');
      return false;
    }
    return true;
  }
}
