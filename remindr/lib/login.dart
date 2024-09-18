import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Certifique-se de importar cupertino.dart
import 'lista.dart';

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
                CupertinoButton(
                  child: Text(
                    'Apply',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
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
