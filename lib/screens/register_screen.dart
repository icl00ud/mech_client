import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mech_client/screens/login_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _selectedItem = "Cliente";
  bool _checkBoxValue = false;
  static double padding = 3;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: "Nome"),
                        ),
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
                              decoration:
                                  const InputDecoration(labelText: "Telefone"),
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
                          return null;
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: padding, bottom: padding),
                            child: TextFormField(
                              controller: _addressController,
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
                              controller: _numberController,
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
                            padding:
                                EdgeInsets.only(top: padding, bottom: padding),
                            child: TextFormField(
                              controller: _zipController,
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
                              controller: _complementController,
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
                          validationRegister();
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
                          builder: (context) =>
                              LoginPage(), // Substitua TelaDeDestino pela classe da tela de destino
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
    ));
  }

  void registerUser() async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // obtem a instancia atual do usuario
      User? user = _firebaseAuth.currentUser;

      // cria um map pro endereço do cliente
      Map<String, dynamic> addressData = {
        'address': _addressController.text,
        'number': _numberController.text,
        'zip': _zipController.text,
        'complement': _complementController.text,
      };

      // armazena na colecao client
      await FirebaseFirestore.instance.collection('client').doc(user?.uid).set({
        'name': _nameController.text,
        'cpf': _cpfController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'address': addressData, // chama o map no cadastro
        'password': _passwordController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro efetuado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
      });

      // validaçoes do cadastro senha e email firebase
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A senha é muito fraca. Tente uma senha mais forte.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Este e-mail já foi cadastrado. Por favor, faça login ou use outro e-mail.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      print('Erro no registro: $e');
    }
  }

  bool isValidEmail(String value) {
    final RegExp emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(value);
  }

  void validationRegister() {
    // lista para verificar os campos vazios
    List<TextEditingController> register = [
      _nameController,
      _cpfController,
      _phoneController,
      _emailController,
      _addressController,
      _numberController,
      _zipController,
      _complementController,
      _passwordController,
      _confirmPasswordController,
    ];
    bool empty = false;

    for (TextEditingController controller in register) {
      if (controller.text.isEmpty) {
        empty = true;
        break;
      }
    }

    if (empty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    } else {
      // verifica se as senhas coincidem
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('As senhas não coincidem. Por favor, tente novamente.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      // verifica se checkbox esta marcada
      if (!_checkBoxValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aceite os termos e políticas.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      registerUser();
    }
  }
}
