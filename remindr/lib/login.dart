import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Certifique-se de importar cupertino.dart
import 'package:navegacao_telas_app/cadastro.dart';
import 'lista.dart';
import 'esqueceu.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
  ));
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título "LOGIN" com fonte maior e centralizado
                Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 36, // Tamanho da fonte
                    fontWeight: FontWeight.bold, // Negrito
                    fontFamily: 'Roboto', // Fonte personalizada
                  ),
                ),
                SizedBox(height: 40), // Espaçamento entre o título e as caixas de texto
                // Caixa de texto para Email
                TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Borda preta ao focar
                    ),
                  ),
                ),
                SizedBox(height: 20), // Espaço entre as caixas de texto
                // Caixa de texto para Senha
                TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Borda preta ao focar
                    ),
                  ),
                ),
                SizedBox(height: 20), // Espaço abaixo das caixas de texto
                // Alinhar o botão "Esqueceu a senha?" à direita
                Align(
                  alignment: Alignment.centerRight,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoButton(
                      child: Text(
                        'Esqueceu a senha?',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Esqueceu())
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20), // Espaçamento entre os botões
                // Botão "Entrar" centralizado
                SizedBox(
                  width: double.infinity, // Largura do botão
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF344955), // Cor do botão
                      padding: EdgeInsets.symmetric(vertical: 15), // Altura do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                      ),
                    ),
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      // Ação do botão "Entrar"
                    },
                  ),
                ),
                SizedBox(height: 20), // Espaço abaixo das caixas de texto
                // Alinhar o botão "Esqueceu a senha?" à direita
                Align(
                  alignment: Alignment.center,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoButton(
                      child: Text(
                        'Não tem uma conta? Cadastre-se',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Cadastro())
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Color(0xFF344955),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 50),
              IconButton(
                icon: Icon(Icons.home, size: 50),
                color: Colors.white,
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.menu, size: 50),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListaDeCompras(showPopup: false),
                    ),
                  );
                },
              ),
              SizedBox(width: 50),
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 90.0,
          width: 90.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaDeCompras(showPopup: true),
                  ),
                );
              },
              child: Icon(Icons.add, size: 40, color: Colors.white),
              shape: StadiumBorder(),
              backgroundColor: Color(0xFFF9AA33),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}


