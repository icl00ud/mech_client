import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mech_client/models/account_user_model.dart';
import 'package:mech_client/services/user_services.dart';
import 'package:mech_client/widgets/button_widget.dart';
import 'package:mech_client/widgets/dialog_confirm_password_widget.dart';

class FormsUser extends StatefulWidget {
  final AccountUser accountUser;
  final UserServices userServices;

  FormsUser({required this.accountUser, required this.userServices, super.key});

  @override
  State<FormsUser> createState() => _FormsUserState();
}

class _FormsUserState extends State<FormsUser> {
  final double padding = 3;
  final _formkey = GlobalKey<FormState>();

  AccountUser accountUser = AccountUser();
  UserServices userServices = UserServices();
  String actualPassword = '';
  bool isEditing = false;

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: TextFormField(
              controller: widget.accountUser.name,
              decoration: const InputDecoration(labelText: "Nome"),
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
                  controller: widget.accountUser.type == "Cliente"
                      ? widget.accountUser.cpf
                      : widget.accountUser.cnpj,
                  decoration: InputDecoration(
                      labelText: widget.accountUser.type == "Cliente"
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
                  controller: widget.accountUser.phone,
                  decoration: const InputDecoration(labelText: "Telefone"),
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
            controller: widget.accountUser.email,
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
                padding: EdgeInsets.only(top: padding, bottom: padding),
                child: TextFormField(
                  controller: widget.accountUser.address.address,
                  decoration: const InputDecoration(labelText: "Rua"),
                  enabled: isEditing,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: TextFormField(
                  controller: widget.accountUser.address.number,
                  decoration: const InputDecoration(labelText: "Nº"),
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
                padding: EdgeInsets.only(top: padding, bottom: padding),
                child: TextFormField(
                  controller: widget.accountUser.address.zip,
                  decoration: const InputDecoration(labelText: "CEP"),
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
                  controller: widget.accountUser.address.complement,
                  decoration: const InputDecoration(labelText: "Complemento"),
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
                  controller: widget.accountUser.password,
                  decoration: const InputDecoration(labelText: "Senha"),
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
                  controller: widget.accountUser.confirmPassword,
                  decoration:
                      const InputDecoration(labelText: "Confirmar senha"),
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
                // ao clicar em editar atualiza a variavel actualPassword
                _loadUserData();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogConfirmPassword(
                        passwordCorrect: actualPassword);
                  },
                ).then(
                  (value) {
                    if (value != null && value) {
                      setState(() {
                        isEditing = true;
                      });
                    }
                  },
                );
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
                      widget.userServices
                          .updateUser(
                              context, actualPassword, widget.accountUser)
                          .then((success) {
                        if (success) {
                          setState(() {
                            widget.userServices.getUser(widget.accountUser);
                            isEditing = false;
                            actualPassword = widget.accountUser.password.text;
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
                      widget.userServices.getUser(widget.accountUser);
                      isEditing = false;
                    });
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _loadUserData() async {
    final userData = await userServices.getUser(accountUser);
    setState(() {
      accountUser = userData!;
      actualPassword = accountUser.password.text;
    });
  }
}
