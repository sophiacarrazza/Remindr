import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Certifique-se de importar cupertino.dart
import 'package:flutter/services.dart';
import 'lista.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    home: Cadastro(),
  ));
}

class Cadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login())
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100), // Espaço para subir os elementos
                Text(
                  'CRIE SUA CONTA',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  cursorColor: Colors.black,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ\s]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome', // Label do campo
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  cursorColor: Colors.black,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ\s]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sobrenome', // Label do campo
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    // Campo CPF
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number, // Teclado numérico
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Aceitar apenas números
                          LengthLimitingTextInputFormatter(11), // Limitar a 11 dígitos
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CPF', // Alterado para CPF
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Espaço entre os dois campos
                    // Campo Data de Nascimento
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number, // Teclado numérico
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Aceitar apenas números
                          LengthLimitingTextInputFormatter(10), // Limitar a 10 caracteres (DD/MM/YYYY)
                          DateTextInputFormatter(), // Formatador personalizado para data
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Data de Nascimento',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: 'DD/MM/AAAA', // Sugestão de formato
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF344955),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Enviar',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      // Ação do botão "Enviar"
                    },
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
class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue,) {
    // Remover todos os caracteres que não sejam números
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8); // Limitar a 8 dígitos
    }

    String formattedDate = '';
    if (digitsOnly.length >= 2) {
      formattedDate = digitsOnly.substring(0, 2); // Dia
      if (digitsOnly.length >= 4) {
        formattedDate += '/' + digitsOnly.substring(2, 4); // Mês
        if (digitsOnly.length > 4) {
          formattedDate += '/' + digitsOnly.substring(4); // Ano
        }
      } else if (digitsOnly.length > 2) {
        formattedDate += '/' + digitsOnly.substring(2); // Mês incompleto
      }
    } else {
      formattedDate = digitsOnly; // Apenas dia incompleto
    }

    return TextEditingValue(
      text: formattedDate,
      selection: TextSelection.collapsed(offset: formattedDate.length),
    );
  }
}



