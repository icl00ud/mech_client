import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _selectedItem = "Cliente"; // Initial value of DropdownMenu
  bool _checkBoxValue = false;
  static double padding = 3;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
                          items: ["Cliente", "Mecânico"].map((String item) {
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
                  padding: const EdgeInsets.only(left: 15, right: 30, top: 5, bottom: 20),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 1,
                          color: Colors.grey,
                          blurRadius: 10,
                          offset: Offset(3, 1)
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(padding),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: "Nome"),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: TextFormField(
                                controller: _cpfController,
                                decoration:
                                    const InputDecoration(labelText: "CPF"),
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
                                controller: _phoneController,
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
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'O campo de e-mail não pode estar vazio.';
                            } else if (!isValidEmail(value)) {
                              return 'O e-mail inserido não é válido.';
                            }
                            return null; // Retorna nulo para indicar que não há erros.
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(padding),
                        child: TextFormField(
                          controller: _addressController,
                          decoration:
                              const InputDecoration(labelText: "Endereço"),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: TextFormField(
                                controller: _passwordController,
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
                                controller: _confirmPasswordController,
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
                                value: _checkBoxValue,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _checkBoxValue = newValue!;
                                  });
                                },
                              )
                          ),
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
                            // Lógica de cadastro
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
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Já tem uma conta?  ',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text: 'Entre aqui!',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF5C00)),
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

bool isValidEmail(String email) {
  final RegExp regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');

  return regex.hasMatch(email);
}
