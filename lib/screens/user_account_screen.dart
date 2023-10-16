import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mech_client/models/client.dart';
import 'package:mech_client/services/user_services.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  static double padding = 3;
  final _formkey = GlobalKey<FormState>();
  Client client = Client();
  UserServices userServices = UserServices();

  bool isEditing = false;

  @override
  void initState() {
    userServices.getUser(client);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  size: 50,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Sua Conta",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFFFF5C00),
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 5, bottom: 30),
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 0,
                          color: Color.fromARGB(150, 0, 0, 0),
                          blurRadius: 4,
                          offset: Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Form(
                        key: _formkey,
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: TextFormField(
                            controller: client.name,
                            decoration:
                                const InputDecoration(labelText: "Nome"),
                            enabled: isEditing,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: TextFormField(
                                controller: client.cpf,
                                decoration:
                                    const InputDecoration(labelText: "CPF"),
                                enabled: false,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                      mask: '###.###.###-##',
                                      filter: {'#': RegExp(r'[0-9]')})
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: TextFormField(
                                controller: client.phone,
                                decoration: const InputDecoration(
                                    labelText: "Telefone"),
                                enabled: isEditing,
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
                          controller: client.email,
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                          enabled: isEditing,
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
                                controller: client.address.address,
                                decoration:
                                    const InputDecoration(labelText: "Rua"),
                                enabled: isEditing,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: TextFormField(
                                controller: client.address.number,
                                decoration:
                                    const InputDecoration(labelText: "Nº"),
                                enabled: isEditing,
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
                                controller: client.address.zip,
                                decoration:
                                    const InputDecoration(labelText: "CEP"),
                                enabled: isEditing,
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
                                controller: client.address.complement,
                                decoration: const InputDecoration(
                                    labelText: "Complemento"),
                                enabled: isEditing,
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
                                controller: client.password,
                                decoration:
                                    const InputDecoration(labelText: "Senha"),
                                enabled: false,
                                obscureText: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 214),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible: !isEditing,
                        child: SizedBox(
                          width: 150,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditing = !isEditing; // Inverte o estado
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF5C00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            child: const Text(
                              'Editar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      if (isEditing)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  userServices
                                      .updateUser(
                                          context, client.password.text, client)
                                      .then((success) {
                                    if (success) {
                                      setState(() {
                                        isEditing = false;
                                      });
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF5C00),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                                child: const Text(
                                  'Salvar',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                            SizedBox(
                              width: 120,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isEditing = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF5C00),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}