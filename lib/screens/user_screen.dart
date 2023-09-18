import 'package:flutter/material.dart';

class User extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: EditScreen(),
      ),
    );
  }
}

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nome'),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'CPF'),
                        ),
                      ),
                      const SizedBox(
                          width:
                              16.0), // Espaçamento entre os campos CPF e Telefone
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Telefone'),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'CEP'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Número'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para editar os dados aqui
                    },
                    child: Text('Editar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
