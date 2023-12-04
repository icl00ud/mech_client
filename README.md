# 📑 Bem-vindo à Documentação do aplicativo do MechClient!
<p>O MechClient é um aplicativo em Flutter que surgiu para suprir a crescente demanda por serviços de manutenção e reparo de veículos na indústria automotiva. Nesta documentação, você encontrará detalhes abrangentes sobre as APIs que alimentam o aplicativo.</p>

## 🚀💻Tecnologias utilizadas

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white) ![Firebase](https://img.shields.io/badge/firebase-ffca28?style=for-the-badge&logo=firebase&logoColor=black) ![SharePoint](https://img.shields.io/badge/Microsoft_SharePoint-0078D4?style=for-the-badge&logo=microsoft-sharepoint&logoColor=white) ![Twilio](https://img.shields.io/badge/Twilio-F22F46?style=for-the-badge&logo=Twilio&logoColor=white)

## 🌐 API Twilio

Neste aplicativo, utilizamos a API Twilio para verificar o número de telefone do usuário.

### 📌 Como Implementar:

#### 1. Registre-se na Twilio:
   - Crie uma conta gratuita na [Twilio](https://www.twilio.com/) para obter as credenciais necessárias.

#### 2. Cadastre Números na Plataforma:
   - Como sua conta é gratuita, para utilizar o serviço de SMS, cadastre números de telefone na aba [Cadastrar Números](https://console.twilio.com/us1/develop/phone-numbers/manage/verified).

#### 3. Obtenha Credenciais:
   - Obtenha o `Account SID`, o `Auth Token` e o `My Twilio phone number` na aba [Console](https://console.twilio.com/?frameUrl=%2Fconsole%3Fx-target-region%3Dus1).

#### 💻 Exemplo de Implementação:

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

## 🔥 Firebase
No nosso projeto, utilizamos o Firebase para serviços como autenticação de usuários `Firebase Authentication` e armazenamento de dados em tempo real `Cloud Firestore`. Siga os passos abaixo para saber como **configurar** o Firebase no seu projeto:

### ⚙️ Configuração

#### 1. Crie um Projeto no Firebase:
   - Acesse o [Console do Firebase](https://console.firebase.google.com/) e crie um novo projeto.

#### 2. Adicione um Aplicativo ao Projeto:
   - Após criar o projeto, clique em "Adicionar aplicativo" e siga as instruções para configurar o aplicativo para iOS, Android ou Web, conforme necessário.

#### 3. Configure o Flutter para o Firebase:
   - Assim que você registrar um aplicativo ao seu projeto baixe o arquivo gerado pelo Firebase `google-services.json` e adicione na pasta `.app` conforme a imagem abaixo.
<center>
<img src="Document\imagem_google-services.png" alt="Imagem exemplo" width="300" height="300">
</center>
<br>


#### 4. Adicione as Dependências necessárias para seu projeto
   - No arquivo `pubspec.yaml` do seu projeto Flutter, inclua as dependências necessárias que utilizará no seu projeto. No nosso caso, como estamos utilizando serviços do Firebase, incluímos `firebase_core`, `firebase_auth` e `cloud_firestore`.

   Exemplo:
   ```yaml
   dependencies:
     firebase_core: ^3.0.0
     firebase_auth: ^4.6.2
     cloud_firestore: ^3.0.0
  ```

#### 5. Inicialize o Firebase no Código Flutter:
No arquivo main.dart, inicialize o Firebase.

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

##  📲 Instalação e Configuração do Flutter

Para executar nosso aplicativo, é necessário ter o Flutter instalado e configurado em sua máquina. Para isso, siga os passos abaixo:

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

**Dependências do Projeto (pubspec.yaml):**
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

## ⚠️ Dificuldades na Instalação ou Configuração do Editor

Caso você encontre dificuldades durante o processo de instalação do Flutter ou precise configurar um editor de código, consulte a [documentação oficial do Flutter](https://docs.flutter.dev/get-started/editor) para obter informações detalhadas.

## :iphone: Gerando APK

### 1. Gerar o APK no Computador 

- No terminal, navegue até o diretório do seu projeto Flutter e execute o seguinte comando para gerar o APK:
```
flutter build apk
```

### 2. Localizar o Arquivo APK Gerado 

- O comando acima irá gerar o arquivo APK na pasta `build/app/outputs/flutter-apk/`. O arquivo APK terá um nome como `app-release.apk`.

### 3. Transferir o APK para o Dispositivo Android 

- Você pode transferir o arquivo APK para o seu dispositivo Android de várias maneiras, como usando um cabo USB, enviando-o por e-mail, usando serviços de armazenamento em nuvem, etc. Certifique-se de salvar o arquivo APK em um local acessível no seu dispositivo.

### 4. Permitir Instalação de Fontes Desconhecidas 

- No seu dispositivo Android, vá para `Configurações > Segurança (ou Configurações > Biometria e Segurança)` e habilite a opção `Fontes Desconhecidas`. Isso permitirá a instalação de aplicativos fora da Play Store.

### 5. Instalar o APK no Dispositivo Android 

- Localize o arquivo APK no seu dispositivo Android usando um gerenciador de arquivos e toque nele para iniciar o processo de instalação.

### 6. Executar o Aplicativo

- Após a instalação, você pode encontrar o aplicativo na tela inicial do seu dispositivo Android e iniciá-lo.

## 📋 Guia MechClient

Este é um guia passo a passo para ajudar você a utilizar nosso aplicativo, especialmente se estiver enfrentando dificuldades de acesso.

### Sumário

- [Cadastro](#1-cadastro-no-aplicativo)
- [Login](#2-login-no-aplicativo)
- [Tela Conta](#3-tela-de-conta)
- [Tela Veículo](#4-tela-veículo)
- [Tela Serviços Cliente](#5-tela-serviços-cliente)
- [Tela Serviços Mecânica](#6-tela-serviços-mecânica)

### 1. Cadastro no Aplicativo

- Se você ainda não possui uma conta no aplicativo, comece clicando no botão `Registre-se aqui!`, conforme mostrado na imagem abaixo.

  <div style="text-align:center;">
    <img src="Document/Registro01.png" alt="Passo 01" width="210" height="450">
  </div>

- Ao clicar neste botão, você será direcionado para a tela de cadastro, onde poderá criar uma conta como **Cliente** ou **Mecânica**.

  <div style="text-align:center;">
    <img src="Document/Registro02.png" alt="Passo 02" width="210" height="450">
  </div>

- Depois de selecionar o tipo de conta, preencha os dados com informações válidas.

### 📞 Verificação do Número de Telefone

- Após preencher todos os dados e não receber nenhum aviso de erro, clique no botão `Cadastrar-se`. Isso abrirá um `Dialog` para inserir os 5 dígitos do código enviado para o seu número de telefone.

  **Observação:** O código enviado por SMS só funcionará para números cadastrados na sua conta Twilio, conforme explicado no [tópico acima](https://github.com/Pellegr1n1/mech_client#-api-twilio).

  <div style="text-align:center;">
    <img src="Document/Registro03.png" alt="Passo 03" width="210" height="450">
  </div>

- Clique em `Verificar Código` e, se o código estiver correto, você receberá um feedback de sucesso, como `Cadastro efetuado com sucesso!`. Caso contrário, será necessário repetir o processo.

### 2. Login no Aplicativo

- Após efetuar o cadastro com sucesso, faça login utilizando as informações cadastradas anteriormente, informando o `email` e a `senha`.

  <div style="text-align:center;">
    <img src="Document/Login01.png" alt="Login" width="210" height="450">
  </div>

### 3. Tela de Conta

- Ao fazer o login no aplicativo, você será direcionado para a tela da conta do usuário, onde terá todas as informações da sua conta.

  <div style="text-align:center;">
    <img src="Document/Conta01.png" alt="Conta" width="210" height="450">
  </div>
  
### ✏️ Editar Informações
- Se desejar editar suas informações, exceto `CPF` e `Telefone`, clique em `Editar`. Será necessário inserir sua senha novamente como medida de segurança.

  <div style="text-align:center;">
    <img src="Document/DialogSenha.png" alt="DialogSenha" width="220" height="200">
  </div>

- Após inserir a senha correta, os campos serão liberados para edição. Ao concluir, clique em `Salvar` e aguarde o feedback.

- Se quiser alterar o número de telefone, clique em `Editar número de telefone`. O campo `Telefone` automaticamente torna-se editável, e ao concluir, a verificação por SMS será acionada novamente para evitar números inválidos.

### ❌ Excluir Conta

- Para poder excluir sua conta abra o menu lateral e clique em `Excluir Conta`.

  <div style="text-align:center;">
    <img src="Document/ExcluirConta.png" alt="DialogSenha" width="210" height="450">
  </div>

- Ao clicar, você receberá uma mensagem de confirmação para excluir sua conta. Caso queira realmente excluir, confirme-a.

  <div style="text-align:center;">
    <img src="Document/ConfirmacaoExclusaoConta.png" alt="DialogSenha" width="210" height="450">
  </div>


### 4. Tela Veículo 

### 🚘 Cadastrar Veículo
- Clique em ``Adicionar Veículo`` para cadastrar e preencha as informações. Caso seu veículo tenha placa Mercosul, ative-a.

Lembre-se: Cada usuário tem um limite de 3 veículos cadastrados.

  <div style="text-align:center;">
    <img src="Document/Veiculo01.png" alt="Conta" width="210" height="450">
    <img src="Document/Veiculo02.png" alt="Conta" width="210" height="450">
  </div>

### ✏️ Editar ou Excluir ❌

- Ao cadastrar seu veículo, você poderá ``Editar`` as informações, exceto a ``Placa``, ou ``Excluir`` seu veículo.

  <div style="text-align:center;">
    <img src="Document/Veiculo03.png" alt="Conta" width="210" height="450">
  </div>

- Ao clicar no ícone de ``Lápis``, você irá editar as informações do veículo.

  <div style="text-align:center;">
    <img src="Document/VeiculoEditar.png" alt="Conta" width="210" height="450">
  </div>

- Ao clicar no icone de ``Lixeira``, você receberá uma mensagem de confirmação para excluir seu veículo. Caso queira realmente excluir, confirme-a.

  <div style="text-align:center;">
    <img src="Document/VeiculoExclusao.png" alt="Conta" width="210" height="450">
  </div>

### 5. Tela Serviços Cliente

### 📡 Solicitando Serviço 

- Na tela de serviços, você poderá solicitar um serviço para seu veículo caso necessário, clicando em ``Solicitar Serviço``.

  <div style="text-align:center;">
    <img src="Document/SolicitarServico.png" alt="Conta" width="210" height="450">
  </div>

- Ao clicar, será necessário preencher o formulário, detalhando o máximo possível para que a mecânica compreenda seu problema.

  <div style="text-align:center;">
    <img src="Document/SolicitandoServico.png" alt="Conta" width="210" height="450">
  </div>

### ❌ Excluir ou Exibir Detalhes 🧾

- Ao solicitar o serviço, você poderá excluí-lo clicando no ícone da ``Lixeira`` e visualizar os detalhes do serviço clicando no botão ``Detalhes``.

  <div style="text-align:center;">
    <img src="Document/Servico.png" alt="Conta" width="210" height="450">
  </div>

### ✅ Serviço Aceito

- Quando seu serviço for aceito por alguma mecânica, ele irá subir automaticamente para aba de `Serviços Aceitos`.

### 6. Tela Serviços Mecânica

### 📡 Aceitando Serviços

- Na aba de serviços da mecânica, você receberá os serviços solicitados por contas de cliente.

  <div style="text-align:center;">
    <img src="Document/ServicoMecanica.png" alt="Conta" width="210" height="450">
  </div>

- Ao clicar em ``Detalhes``, você poderá ver as informações sobre o serviço e poderá aceitar clicando no botão ``Aceitar``.

  <div style="text-align:center;">
    <img src="Document/ServicoMecanicaAceitar.png" alt="Conta" width="210" height="450">
  </div>

- Ao aceitar o serviço, será direcionado para a aba de ``Serviços Aceitos`` e ao clicar em ``Detalhes`` novamente, você poderá entrar em contato com o cliente através do botão ``WhatsApp``.

  <div style="text-align:center;">
    <img src="Document/ServicoMecanicaWhatsapp.png" alt="Conta" width="210" height="450">
  </div>


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
