# 📑 Bem-vindo à Documentação do aplicativo do MechClient!
<p>O MechClient é um aplicativo em Flutter que surgiu para suprir a crescente demanda por serviços de manutenção e reparo de veículos na indústria automotiva. Nesta documentação, você encontrará detalhes abrangentes sobre as APIs que alimentam o aplicativo.</p>

## 🚀💻Tecnologias utilizadas

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-ffca28?style=for-the-badge&logo=firebase&logoColor=black)
![SharePoint](https://img.shields.io/badge/Microsoft_SharePoint-0078D4?style=for-the-badge&logo=microsoft-sharepoint&logoColor=white)
![Twilio](https://img.shields.io/badge/Twilio-F22F46?style=for-the-badge&logo=Twilio&logoColor=white)

# API Twilio

Neste aplicativo, utilizamos a API Twilio para verificar o número de telefone do usuário. A Twilio é uma plataforma de comunicação em nuvem que oferece serviços como envio de mensagens SMS, chamadas telefônicas e verificação de números de telefone.

## ⚙️ Funcionamento

1. **Cadastro na Twilio:**
   - Crie uma conta gratuita na [Twilio](https://www.twilio.com/) para obter as credenciais necessárias.

2. **Cadastro de Número na Plataforma:**
   - Como sua conta é gratuita, para utilizar o serviço de SMS, cadastre um número real na aba [Cadastrar Números](https://console.twilio.com/us1/develop/phone-numbers/manage/verified).

3. **Geração de Credenciais:**
   - Obtenha o Account SID, o Auth Token e o My Twilio phone number.

## Exemplo de Implementação:

```dart
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class TwilioService {
  final String accountSid = 'SEU_ACCOUNT_SID';
  final String authToken = 'SEU_AUTH_TOKEN';
  final String twilioNumber = 'SEU_NUMERO_TWILIO';
  final String number = 'NUMERO_TELEFONE';

  int codigo = 10000 + Random().nextInt(90000);

  Future<void> enviarSMS() async {
    final Uri uri = Uri.parse(
        'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');
    final http.Client client = http.Client();

    try {
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
    } catch (e) {
      print('Erro ao enviar SMS: $e');
    } finally {
      client.close();
    }
  }

  Future<bool> verificarCodigo() async {
    String codigoInserido = codigoController.text;
    return codigoInserido == codigo.toString();
  }
}
```
Lembre-se de substituir as informações de autenticação e números pelos dados específicos da sua conta Twilio.


# ![Flutter](https://skillicons.dev/icons?i=flutter&perline=3) Instalação

Para executar este aplicativo, é necessário ter o Flutter instalado e configurado em sua máquina. Siga os passos abaixo:

### 1. Download do Flutter SDK:

- Baixe a versão mais recente do [Flutter SDK](https://docs.flutter.dev/get-started/install) no site oficial.

### 2. Extração do Arquivo ZIP:

- Extraia o arquivo ZIP e adicione o caminho ao `PATH`.

### 3. Configuração do Flutter:

- Execute `flutter --version` no prompt de comando para verificar a instalação.

### 4. Download do Android Studio:

- Baixe e instale o [Android Studio](https://developer.android.com/studio).
- Abra o Android Studio, vá para "Configure" > "Plugins" e instale o plugin Flutter.

### 5. Verificação de Dependências:

- Execute `flutter doctor` no prompt de comando para verificar e instalar dependências.

### 6. Baixando Dependências:

- Após a instalação bem-sucedida, clone este repositório e execute o comando `flutter pub get` para baixar as dependências do projeto.

#### Dependências do Projeto (pubspec.yaml):
```yaml
dependencies:
  font_awesome_flutter: ^10.6.0
  url_launcher: ^6.2.1
  cpf_cnpj_validator: 2.0.0
  firebase_core: ^2.13.1
  firebase_auth: ^4.6.2
  cloud_firestore:
  mask_text_input_formatter: ^2.5.0
  cupertino_icons: ^1.0.2
  date_time_picker: ^2.1.0
  intl: ^0.17.0
  http: ^1.1.0
  pinput: ^3.0.1
```
### 7. Rodando Aplicativo:
- Após baixar todas as dependências do projeto, execute a aplicação usando o comando `flutter run`.

# ⚠️ Dificuldades na Instalação ou Configuração do Editor

Caso você encontre dificuldades durante o processo de instalação do Flutter ou precise configurar um editor de código, consulte a [documentação oficial do Flutter](https://docs.flutter.dev/get-started/editor) para obter informações detalhadas.


<h4 align="center"> 
	🚧  Aplicativo MechClient 🚀 Em construção...  🚧
</h4>

<br>
<br>

<h2 align="center">Contribuidores</h2>
<table align="center">
  <tr>
    <td align="center"><a href="https://rocketseat.com.br"><img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/118866895?s=400&u=a12412e21705d58ab604be67c1e1431c80174b64&v=4" width="100px;" alt=""/><br /><sub><b>Humberto Peresd</b></sub></a><br /><a href="https://rocketseat.com.br/" title="Rocketseat">👨‍🚀</a></td>
    <td align="center"><a href="https://rocketseat.com.br"><img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/117309594?v=4" width="100px;" alt=""/><br /><sub><b>Weslly Neres</b></sub></a><br /><a href="https://rocketseat.com.br/" title="Rocketseat">👨‍🚀</a></td>
    <td align="center"><a href="https://rocketseat.com.br"><img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/119978954?v=4" width="100px;" alt=""/><br /><sub><b>Leandro Pellegrini</b></sub></a><br /><a href="https://rocketseat.com.br/" title="Rocketseat">👨‍🚀</a></td>
    <td align="center"><a href="https://rocketseat.com.br"><img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/104214178?v=4" width="100px;" alt=""/><br /><sub><b>Vítor Celestino</b></sub></a><br /><a href="https://rocketseat.com.br/" title="Rocketseat">🚀</a></td>
    <td align="center"><a href="https://rocketseat.com.br"><img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/98751190?v=4" width="100px;" alt=""/><br /><sub><b>Israel Moreira</b></sub></a><br /><a href="https://rocketseat.com.br/" title="Rocketseat">🚀</a></td>
  </tr>
</table>
