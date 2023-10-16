import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mech_client/models/client.dart';
import 'package:mech_client/models/mechanic.dart';
import 'package:mech_client/screens/login_screen.dart';
import 'package:mech_client/services/user_services.dart';
import 'package:mech_client/services/validationUser.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  static String _selectedItem = "Cliente";
  static double padding = 3;

  Mechanic mechanic = Mechanic();
  Client client = Client();
  ValidationUser validation = ValidationUser();
  UserServices userServices = UserServices();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login-page_background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    const Text(
                      'Criar conta',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF5C00)),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Deseja cadastrar-se como?',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFECECEC),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(2, 3.1),
                            ),
                          ],
                        ),
                        child: DropdownButton(
                          value: _selectedItem,
                          items: ["Cliente", "Mecânica"].map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          isExpanded: true,
                          underline: const SizedBox(),
                          padding: const EdgeInsets.only(left: 15, right: 5),
                          iconSize: 36,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedItem = value ?? "Cliente";
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 30, top: 5, bottom: 20),
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 1,
                          color: Colors.grey,
                          blurRadius: 10,
                          offset: Offset(3, 1)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Form(
                        key: _formkey,
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: TextFormField(
                            controller: _selectedItem == "Cliente"
                                ? client.name
                                : mechanic.name,
                            decoration:
                                const InputDecoration(labelText: "Nome"),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: TextFormField(
                                controller: _selectedItem == "Cliente"
                                    ? client.cpf
                                    : mechanic.cnpj,
                                decoration: InputDecoration(
                                    labelText: _selectedItem == "Cliente"
                                        ? "CPF"
                                        : "CNPJ"),
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: _selectedItem == "Cliente"
                                        ? '###.###.###-##'
                                        : '##.###.###/####-##',
                                    filter: {'#': RegExp(r'[0-9]')},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: TextFormField(
                                controller: _selectedItem == "Cliente"
                                    ? client.phone
                                    : mechanic.phone,
                                decoration: const InputDecoration(
                                    labelText: "Telefone"),
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                      mask: '(##) #####-####',
                                      filter: {'#': RegExp(r'[0-9]')})
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(padding),
                        child: TextFormField(
                          controller: _selectedItem == "Cliente"
                              ? client.email
                              : mechanic.email,
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: padding, bottom: padding),
                              child: TextFormField(
                                controller: _selectedItem == "Cliente"
                                    ? client.address.address
                                    : mechanic.address.address,
                                decoration:
                                    const InputDecoration(labelText: "Rua"),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: TextFormField(
                                controller: _selectedItem == "Cliente"
                                    ? client.address.number
                                    : mechanic.address.number,
                                decoration:
                                    const InputDecoration(labelText: "Nº"),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
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
                              padding: EdgeInsets.only(
                                  top: padding, bottom: padding),
                              child: TextFormField(
                                controller: _selectedItem == "Cliente"
                                    ? client.address.zip
                                    : mechanic.address.zip,
                                decoration:
                                    const InputDecoration(labelText: "CEP"),
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: '#####-###',
                                    filter: {"#": RegExp(r'[0-9]')},
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: TextFormField(
                                controller: _selectedItem == "Cliente"
                                    ? client.address.complement
                                    : mechanic.address.complement,
                                decoration: const InputDecoration(
                                    labelText: "Complemento"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: TextFormField(
                                controller: _selectedItem == "Cliente"
                                    ? client.password
                                    : mechanic.password,
                                decoration:
                                    const InputDecoration(labelText: "Senha"),
                                obscureText: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: TextFormField(
                                controller: _selectedItem == "Cliente"
                                    ? client.confirmPassword
                                    : mechanic.confirmPassword,
                                decoration: const InputDecoration(
                                    labelText: "Confirmar senha"),
                                obscureText: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Checkbox(
                                value: ValidationUser.checkBoxValue,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    ValidationUser.checkBoxValue = newValue!;
                                  });
                                },
                              )),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text("Concordo com os termos e políticas"),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_selectedItem == "Cliente") {
                              setState(() {
                                userServices.registerClient(context, client);
                              });
                            } else {
                              setState(() {
                                userServices.registerMechanic(
                                    context, mechanic);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5C00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          child: const Text(
                            'Cadastrar-se',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Já tem conta? ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Entre aqui!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF5C00),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
