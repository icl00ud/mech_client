import 'package:flutter/material.dart';

import 'address_model.dart';

class AccountUser {
  Address address;
  TextEditingController name;
  TextEditingController email;
  TextEditingController password;
  TextEditingController confirmPassword;
  TextEditingController phone;
  TextEditingController cpf;
  TextEditingController cnpj;
  List<String> vehicles;
  String userId;
  String type;

  AccountUser({
    Address? address,
    TextEditingController? name,
    TextEditingController? email,
    TextEditingController? password,
    TextEditingController? confirmPassword,
    TextEditingController? phone,
    TextEditingController? cpf,
    TextEditingController? cnpj,
    List<String>? vehicles,
    String? userId,
    String? type,
  })  : address = address ?? Address(),
        name = name ?? TextEditingController(),
        email = email ?? TextEditingController(),
        password = password ?? TextEditingController(),
        confirmPassword = confirmPassword ?? TextEditingController(),
        phone = phone ?? TextEditingController(),
        cpf = cpf ?? TextEditingController(),
        cnpj = cnpj ?? TextEditingController(),
        vehicles = vehicles ?? const [],
        userId = userId ?? '',
        type = type ?? '';

  AccountUser.fromMap(Map<String, dynamic> map)
      : address = Address(),
        name = TextEditingController(text: map['name']),
        email = TextEditingController(text: map['email']),
        password = TextEditingController(),
        confirmPassword = TextEditingController(),
        phone = TextEditingController(text: map['phone']),
        cpf = TextEditingController(text: map['cpf']),
        cnpj = TextEditingController(text: map['cnpj']),
        vehicles = List<String>.from(map['vehicles'] ?? []),
        userId = map['userId'],
        type = map['type'];

  Map<String, dynamic> toMap() {
    return {
      'name': name.text,
      'email': email.text,
      'phone': phone.text,
      'cpf': cpf.text,
      'cnpj': cnpj.text,
      'vehicles': vehicles,
      'userId': userId,
      'type': type,
      'address': {
        'address': address.address.text,
        'number': address.number.text,
        'zip': address.zip.text,
        'complement': address.complement.text,
      },
    };
  }
}