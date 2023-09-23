# 📑 Bem-vindo à Documentação do aplicativo do MechClient!
<p>O MechClient é um aplicativo Flutter que surgiu para suprir a crescente demanda por serviços de manutenção e reparo de veículos na indústria automotiva. Nesta documentação, você encontrará detalhes abrangentes sobre as APIs que alimentam o aplicativo.</p>

## 🚀💻Tecnoligias utilizadas

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-ffca28?style=for-the-badge&logo=firebase&logoColor=black)
![Github](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)
![Trello](https://img.shields.io/badge/Trello-0052CC?style=for-the-badge&logo=trello&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

## Classe UserAccount
A classe UserAccount é responsável por gerenciar a interface da tela de perfil do usuário em um aplicativo Flutter. Ela permite que o usuário visualize e edite suas informações de perfil, como nome, CPF, telefone, email, endereço e senha.

### `Construtor`
#### UserAccount()

Cria uma instância da classe UserAccount para gerenciar a tela de perfil do usuário.

### `Métodos e Propriedades`
#### initState
O método initState é chamado quando o widget é inicializado e é usado para carregar as informações do usuário a partir do Firebase Authentication e Firebase Firestore.

#### build
O método build constrói a interface da tela de perfil do usuário. Ele inclui elementos visuais para exibir e editar as informações do usuário, como nome, CPF, telefone, email, endereço e senha. Além disso, ele permite alternar entre os modos de visualização e edição.

### `Propriedades de Controller`
_nameController: Controla o campo de texto para o nome do usuário.<br>
_emailController: Controla o campo de texto para o email do usuário.<br>
_passwordController: Controla o campo de texto para a senha do usuário.<br>
_phoneController: Controla o campo de texto para o telefone do usuário.<br>
_cpfController: Controla o campo de texto para o CPF do usuário.<br>
_addressController: Controla o campo de texto para o endereço do usuário.<br>
_numberController: Controla o campo de texto para o número de endereço do usuário.<br>
_zipController: Controla o campo de texto para o CEP do usuário.<br>
_complementController: Controla o campo de texto para o complemento do endereço do usuário.<br>
_formkey<br>
Uma chave global (GlobalKey) para o formulário que é usado para validar os campos de entrada de dados.

#### `_firebaseAuth`
Uma instância do Firebase Authentication para gerenciar a autenticação do usuário.

#### `isEditing`
Uma variável booleana que controla se o usuário está no modo de edição ou visualização.

### `Métodos Privados`
**getUser:** Obtém as informações do usuário do Firebase Authentication e Firebase Firestore e preenche os campos de texto correspondentes.

**updateUser:** Atualiza as informações do usuário no Firebase Authentication e no Firebase Firestore, incluindo nome, email, telefone, endereço e senha. Ele também lida com a reautenticação do usuário para atualizar as credenciais.

**isValidEmail:** Verifica se uma string é um endereço de email válido usando uma expressão regular.

Esta classe fornece uma interface de usuário para que os usuários possam visualizar e editar suas informações de perfil de forma segura e eficiente.

## Classe RegisterPage
A classe RegisterPage é responsável por gerenciar a interface da tela de registro de usuários em um aplicativo Flutter. Ela permite que os usuários se cadastrem como clientes ou mecânicos e preencham informações como nome, CPF, telefone, email, endereço e senha.

### `Construtor`
#### RegisterPage()

Cria uma instância da classe RegisterPage para gerenciar a tela de registro de usuários.

### `Métodos e Propriedades`
#### build
O método build constrói a interface da tela de registro de usuários. Ele inclui elementos visuais para a seleção do tipo de cadastro (cliente ou mecânico) e campos para preenchimento de informações pessoais, como nome, CPF, telefone, email, endereço e senha.

### `Propriedades de Controller`
_nameController: Controla o campo de texto para o nome do usuário.<br>
_emailController: Controla o campo de texto para o email do usuário.<br>
_passwordController: Controla o campo de texto para a senha do usuário.<br>
_confirmPasswordController: Controla o campo de texto para confirmar a senha do usuário.<br>
_phoneController: Controla o campo de texto para o telefone do usuário.<br>
_cpfController: Controla o campo de texto para o CPF do usuário.<br>
_addressController: Controla o campo de texto para o endereço do usuário.<br>
_numberController: Controla o campo de texto para o número de endereço do usuário.<br>
_zipController: Controla o campo de texto para o CEP do usuário.<br>
_complementController: Controla o campo de texto para o complemento do endereço do usuário.<br>
_formkey<br>
Uma chave global (GlobalKey) para o formulário que é usado para validar os campos de entrada de dados.

#### `_firebaseAuth`
Uma instância do Firebase Authentication para gerenciar o processo de registro do usuário.

#### `_selectedItem`
Uma variável que armazena o tipo de cadastro selecionado pelo usuário (cliente ou mecânico).

#### `_checkBoxValue`
Uma variável booleana que controla se o usuário concorda com os termos e políticas.

**Métodos Privados**
**registerUser:** Cria uma nova conta de usuário usando o Firebase Authentication com o email e senha fornecidos. Também armazena informações adicionais, como nome, CPF, telefone e endereço, no Firebase Firestore na coleção 'client'.

**isValidEmail:** Verifica se uma string é um endereço de email válido usando uma expressão regular.

**validationRegister:** Realiza validações no formulário de registro, como campos vazios, coincidência de senhas e aceitação dos termos e políticas. Em caso de erro, exibe mensagens apropriadas ao usuário.

Esta classe fornece uma interface de usuário para que os usuários possam se cadastrar em seu aplicativo de forma segura e eficiente, permitindo que escolham o tipo de cadastro desejado e preencham informações pessoais.

## Classe UserAccount
A classe UserAccount é responsável por gerenciar a interface da tela de perfil de usuário em um aplicativo Flutter. Ela permite que os usuários visualizem e, se permitido, editem as informações de seu perfil, como nome, CPF, telefone, email, endereço e senha.

### `Construtor`
#### UserAccount()

Cria uma instância da classe UserAccount para gerenciar a tela de perfil de usuário.

### `Métodos e Propriedades`
#### initState
O método initState é chamado quando o widget é inserido na árvore de widgets pela primeira vez. Neste caso, ele é usado para carregar as informações do usuário chamando o método getUser quando o widget é inicializado.

#### build
O método build constrói a interface da tela de perfil de usuário. Ele inclui elementos visuais para exibir informações do usuário e permite a edição dessas informações quando o usuário opta por editar seu perfil.

Propriedades de Controller
_nameController: Controla o campo de texto para o nome do usuário.<br>
_emailController: Controla o campo de texto para o email do usuário.<br>
_passwordController: Controla o campo de texto para a senha do usuário.<br>
_phoneController: Controla o campo de texto para o telefone do usuário.<br>
_cpfController: Controla o campo de texto para o CPF do usuário.<br>
_addressController: Controla o campo de texto para o endereço do usuário.<br>
_numberController: Controla o campo de texto para o número de endereço do usuário.<br>
_zipController: Controla o campo de texto para o CEP do usuário.<br>
_complementController: Controla o campo de texto para o complemento do endereço do usuário.<br>
_formkey<br>
Uma chave global (GlobalKey) para o formulário que é usado para validar os campos de entrada de dados.

#### `_firebaseAuth`
Uma instância do Firebase Authentication para gerenciar o processo de atualização do perfil do usuário.

#### `isEditing`
Uma variável booleana que controla se o usuário está atualmente editando seu perfil ou apenas visualizando as informações.

### `Métodos Privados`
**getUser:** Obtém informações do usuário atualmente logado no Firebase Authentication e preenche os campos de texto do perfil com essas informações.

**updateUser:** Atualiza as informações do perfil do usuário no Firebase Authentication e no Firebase Firestore. Ele também lida com a reautenticação do usuário antes de atualizar o email e a senha.

**isValidEmail:** Verifica se uma string é um endereço de email válido usando uma expressão regular.

Esta classe fornece uma interface de usuário para que os usuários possam visualizar e editar as informações de seu perfil. O usuário pode optar por editar o perfil clicando no botão "Editar" e, em seguida, salvar ou cancelar as alterações.

<br>
<br>
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
