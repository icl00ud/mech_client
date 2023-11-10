import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mech_client/models/account_user.dart';
import 'package:mech_client/services/user_services.dart';
import 'package:mech_client/widgets/button_widget.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  double padding = 3;
  final _formkey = GlobalKey<FormState>();

  String actualPassword = "";

  AccountUser accountUser = AccountUser();
  UserServices userServices = UserServices();

  bool isEditing = false;

  @override
  void initState() {
    userServices.getUser(accountUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AccountUser?>(
      future: userServices.getUser(accountUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Erro ao carregar os dados do usuário'),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: Text('Nenhum dado do usuário encontrado'),
            ),
          );
        }
        accountUser = snapshot.data!;
        actualPassword = accountUser.password.text;

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
                                controller: accountUser.name,
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
                                    controller: accountUser.type == "Cliente"
                                        ? accountUser.cpf
                                        : accountUser.cnpj,
                                    decoration: InputDecoration(
                                        labelText: accountUser.type == "Cliente"
                                            ? "CPF"
                                            : "CNPJ"),
                                    enabled: false,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(padding),
                                  child: TextFormField(
                                    controller: accountUser.phone,
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
                              controller: accountUser.email,
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
                                    controller: accountUser.address.address,
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
                                    controller: accountUser.address.number,
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
                                    controller: accountUser.address.zip,
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
                                    controller: accountUser.address.complement,
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
                                    controller: accountUser.password,
                                    decoration: const InputDecoration(
                                        labelText: "Senha"),
                                    obscureText: true,
                                    enabled: isEditing,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(padding),
                                  child: TextFormField(
                                    controller: accountUser.confirmPassword,
                                    decoration: const InputDecoration(
                                        labelText: "Confirmar senha"),
                                    obscureText: true,
                                    enabled: isEditing,
                                  ),
                                ),
                              ),
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
                              child: Button(
                                text: "Editar",
                                function: () {
                                  setState(() {
                                    isEditing = !isEditing; // Inverte o estado
                                  });
                                },
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
                                    child: Button(
                                      text: "Salvar",
                                      function: () {
                                        userServices
                                            .updateUser(context, actualPassword,
                                                accountUser)
                                            .then((success) {
                                          if (success) {
                                            setState(() {
                                              userServices.getUser(accountUser);
                                              isEditing = false;
                                            });
                                          }
                                        });
                                      },
                                    )),
                                const SizedBox(width: 40),
                                SizedBox(
                                  width: 120,
                                  height: 40,
                                  child: Button(
                                    text: "Cancelar",
                                    function: () {
                                      setState(() {
                                        userServices.getUser(accountUser);
                                        isEditing = false;
                                      });
                                    },
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
      },
    );
  }
}
