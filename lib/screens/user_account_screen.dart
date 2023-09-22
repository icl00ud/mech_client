import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mech_client/services/authentication.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  static double padding = 3;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isEditing = false;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_emailController.text);
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
                            controller: _nameController,
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
                                controller: _cpfController,
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
                                controller: _phoneController,
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
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                          enabled: isEditing,
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
                              padding: EdgeInsets.only(
                                  top: padding, bottom: padding),
                              child: TextFormField(
                                controller: _addressController,
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
                                controller: _numberController,
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
                                controller: _zipController,
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
                                controller: _complementController,
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
                                controller: _passwordController,
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
                                  updateUser(
                                    context,
                                    _passwordController.text,
                                  ).then((success) {
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
                                  backgroundColor: Color(0xFFFF5C00),
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

  void getUser() async {
    try {
      User? user = await _firebaseAuth.currentUser;
      if (user != null) {
        var collection = FirebaseFirestore.instance.collection('client');
        DocumentSnapshot snapshot = await collection.doc(user.uid).get();

        if (snapshot.exists) {
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;
          _nameController.text = userData['name'] ?? 'campo vazio';
          _cpfController.text = userData['cpf'] ?? 'campo vazio';
          _phoneController.text = userData['phone'] ?? 'campo vazio';
          _emailController.text = userData['email'] ?? 'campo vazio';
          _addressController.text =
              userData['address']['address'] ?? 'campo vazio';
          _numberController.text =
              userData['address']['number'] ?? 'campo vazio';
          _zipController.text = userData['address']['zip'] ?? 'campo vazio';
          _complementController.text =
              userData['address']['complement'] ?? 'campo vazio';
          _passwordController.text = userData['password'] ?? 'campo vazio';
        }
      }
    } catch (e) {
      print('Erro ao obter informações do usuário: $e');
    }
  }

  Future<bool> updateUser(BuildContext context, String senhaAtual) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // cria um objeto AuthCredential para reautenticação
        var credential = EmailAuthProvider.credential(
          email: user.email!,
          password: senhaAtual,
        );

        // reautentique o usuário
        await user.reauthenticateWithCredential(credential);

        // atualiza o email e a senha do usuário
        await user.updateEmail(_emailController.text);
        await user.updatePassword(_passwordController.text);

        var collection = FirebaseFirestore.instance.collection('client');

        DocumentSnapshot snapshot = await collection.doc(user.uid).get();

        if (snapshot.exists) {
          // obtem os dados do documento
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;

          // atualize os campos desejados
          userData['name'] = _nameController.text;
          userData['email'] = _emailController.text;
          userData['phone'] = _phoneController.text;

          // atualiza os campos do map endereço
          Map<String, dynamic> addressData = {
            'address': _addressController.text,
            'number': _numberController.text,
            'zip': _zipController.text,
            'complement': _complementController.text,
          };
          //atualiza o map endereço pelo novo
          userData['address'] = addressData;

          await collection.doc(user.uid).update(userData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cadastro atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );

          return true;
        }
      }
      return false;

      // validações do FireBaseAuthenticator
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
      return false;
    } catch (e) {
      print('Erro ao atualizar informações do usuário: $e');

      return false;
    }
  }

  bool isValidEmail(String value) {
    final RegExp emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(value);
  }
}
