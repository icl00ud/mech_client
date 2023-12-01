// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mech_client/models/account_user_model.dart';
import 'package:mech_client/services/user_services.dart';
import 'package:mech_client/services/validations/sms_validation.dart';
import 'package:mech_client/utils/constans_utils.dart';
import 'package:mech_client/utils/feedback_utils.dart';
import 'package:mech_client/widgets/button_widget.dart';
import 'package:mech_client/widgets/dialog_confirm_password_widget.dart';
import 'package:pinput/pinput.dart';

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
  bool isEditingPhone = false;

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
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: TextFormField(
                  controller: widget.accountUser.phone,
                  decoration: const InputDecoration(labelText: "Telefone"),
                  enabled: isEditingPhone,
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '+55 (##) #####-####',
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
          child: Column(
            children: [
              SizedBox(
                width: 150,
                height: 40,
                child: !isEditingPhone
                    ? Button(
                        text: "Editar",
                        function: () {
                          _loadUserData();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogConfirmPassword(
                                passwordCorrect: actualPassword,
                              );
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
                      )
                    : Button(
                        text: "Salvar",
                        function: () async {
                          {
                            TextEditingController phoneController = TextEditingController(text: widget.accountUser.phone.text);
                            SmsVerification smsVerification = SmsVerification(number: widget.accountUser.phone.text);

                            bool codigoVerificado = false;
                            if (phoneController.text.isEmpty) {
                              FeedbackUtils.showErrorSnackBar(context,
                                  "Por favor, preencha o campo telefone");
                            } else {
                              await smsVerification.enviarSMS();

                              codigoVerificado = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    iconPadding: const EdgeInsets.all(5.0),
                                    title: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text('Verificação de Telefone'),
                                    ),
                                    icon: Container(
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.topRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.close,
                                                size: 25),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.mobile_friendly_outlined,
                                                size: 30,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                      left: 25,
                                      right: 25,
                                      bottom: 15,
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            textAlign: TextAlign.center,
                                            controller: phoneController,
                                            enabled: false, // Disable editing
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                          Pinput(
                                            controller: smsVerification.codigoController,
                                            length: 5,
                                            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                                            showCursor: true,
                                            defaultPinTheme: PinTheme(
                                              width: 56,
                                              height: 56,
                                              textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.w600),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        152, 157, 161, 1)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                          Button(
                                            function: () async {
                                              bool verificado = await smsVerification.verificarCodigo();
                                              Navigator.of(context).pop(verificado);
                                            },
                                            text: 'Verificar Código',
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              smsVerification.enviarSMS();
                                            },
                                            child: const Text(
                                              "Reenviar SMS",
                                              style: TextStyle(
                                                  color: primaryColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            // Code correct
                            if (codigoVerificado) {
                              widget.userServices.updateUser(context, actualPassword, widget.accountUser).then((success) {
                                if (success) {
                                  setState(() {
                                    widget.userServices.getUser(widget.accountUser);
                                    isEditingPhone = false;
                                    actualPassword = widget.accountUser.password.text;
                                  });
                                }
                              });
                            } else {
                              if (phoneController.text.isNotEmpty) {
                                FeedbackUtils.showErrorSnackBar(
                                    context, "Falha na verificação do código");
                              }
                            }
                          }
                        },
                      ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    isEditingPhone = !isEditingPhone;
                    widget.userServices.getUser(widget.accountUser);
                  });
                },
                child: Text(
                  isEditingPhone ? "Cancelar" : "Editar número de telefone",
                  style: const TextStyle(
                    color: primaryColor,
                  ),
                ),
              ),
            ],
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
