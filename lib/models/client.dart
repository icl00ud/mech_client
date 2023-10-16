import 'package:flutter/material.dart';
import 'package:mech_client/models/address.dart';

class Client {
  Address address = Address();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController cpf = TextEditingController();
}
