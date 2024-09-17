import 'package:flutter/material.dart';
import 'lista.dart';
import 'main.dart';
import 'package:cupertino_text_button/cupertino_text_button.dart';

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
        appBar: AppBar(),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 20), // Espaço entre as caixas de texto
                // Caixa de texto para Senha
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                  ),
                ),
                CupertinoTextButton(
                  text: 'Apply',
                  style: const TextStyle(fontSize: 20),
                  onTap: () {
                    // Do your text stuff here.
                  },
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
              IconButton(
                icon: Icon(Icons.home),
                color: Colors.white,
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  // Ação do botão Home
                },
              ),
              IconButton(
                icon: Icon(Icons.menu),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListaDeCompras(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

