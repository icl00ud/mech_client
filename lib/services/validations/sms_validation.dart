import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SmsVerification {
  final String number;
  final String accountSid = 'AC9fe9a7c2306deacb66fa86f9249598dc';
  final String authToken = 'f1c034b15a28042da9a23ce7bed7117a';
  final String twilioNumber = '+14843098091';

  SmsVerification({required this.number});

  int codigo = 10000 + Random().nextInt(90000);
  TextEditingController codigoController = TextEditingController();

  Future<void> enviarSMS() async {
    final Uri uri = Uri.parse(
        'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');
    final http.Client client = http.Client();

    final http.Response response = await client.post(
      uri,
      headers: <String, String>{
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
      },
      body: <String, String>{
        'From': twilioNumber,
        'To': number,
        'Body': 'Seu código de verificação: $codigo',
      },
    );

    print('Status Code: ${response.statusCode}');

    client.close();
  }

  Future<bool> verificarCodigo() async {
    String codigoInserido = codigoController.text;
    return codigoInserido == codigo.toString();
  }
}
