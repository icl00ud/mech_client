// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mech_client/models/account_user_model.dart';
import 'package:mech_client/screens/login_screen.dart';
import 'package:mech_client/services/user_services.dart';
import 'package:mech_client/services/validations/user_validation.dart';
import 'package:mech_client/utils/constans_utils.dart';
import 'package:mech_client/utils/feedback_utils.dart';
import 'package:mech_client/widgets/button_widget.dart';
import 'package:mech_client/services/validations/sms_validation.dart';
import 'package:pinput/pinput.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  static String selectedItem = "Cliente";
  static double padding = 3;

  AccountUser accountUser = AccountUser();
  UserValidation validation = UserValidation();
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
                          color: primaryColor),
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
                          value: selectedItem,
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
                              selectedItem = value ?? "Cliente";
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
                            keyboardType: TextInputType.name,
                            controller: accountUser.name,
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
                                keyboardType: TextInputType.number,
                                controller: selectedItem == "Cliente"
                                    ? accountUser.cpf
                                    : accountUser.cnpj,
                                decoration: InputDecoration(
                                    labelText: selectedItem == "Cliente"
                                        ? "CPF"
                                        : "CNPJ"),
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: selectedItem == "Cliente"
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
                                keyboardType: TextInputType.phone,
                                controller: accountUser.phone,
                                decoration: const InputDecoration(
                                    labelText: "Telefone"),
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
                          controller: accountUser.email,
                          keyboardType: TextInputType.emailAddress,
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
                                keyboardType: TextInputType.streetAddress,
                                controller: accountUser.address.address,
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
                                controller: accountUser.address.number,
                                keyboardType: TextInputType.number,
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
                                controller: accountUser.address.zip,
                                keyboardType: TextInputType.number,
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
                                keyboardType: TextInputType.name,
                                controller: accountUser.address.complement,
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
                                controller: accountUser.password,
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
                                controller: accountUser.confirmPassword,
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
                                activeColor: primaryColor,
                                value: UserValidation.checkBoxValue,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    UserValidation.checkBoxValue = newValue!;
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
                        child: Button(
                          text: "Cadastrar-se",
                          function: () async {
                            if (UserValidation.validationFieldsUser(
                                context, accountUser, selectedItem)) {
                              TextEditingController phoneController =
                                  TextEditingController(
                                      text: accountUser.phone.text);
                              SmsVerification smsVerification = SmsVerification(
                                  number: accountUser.phone.text);

                              bool codigoVerificado = false;

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
                                            controller: smsVerification
                                                .codigoController,
                                            length: 5,
                                            pinputAutovalidateMode:
                                                PinputAutovalidateMode.onSubmit,
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
                                              bool verificado =
                                                  await smsVerification
                                                      .verificarCodigo();
                                              Navigator.of(context)
                                                  .pop(verificado);
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

                              // Code correct
                              if (codigoVerificado) {
                                setState(() {
                                  userServices.registerUser(
                                      context, accountUser, selectedItem);
                                });
                              } else {
                                // Code incorrect
                                FeedbackUtils.showErrorSnackBar(
                                    context, "Falha na verificação do código");
                                print('Falha na verificação do código');
                              }
                            }
                          },
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
                        Navigator.of(context).pushReplacement(
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
                          color: primaryColor,
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
