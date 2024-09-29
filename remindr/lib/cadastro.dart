import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lista.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    home: Cadastro(),
  ));
}

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
          title: Center(
            child: Text('CRIE SUA CONTA',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                )),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                TextField(
                  cursorColor: Colors.black,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ\s]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  cursorColor: Colors.black,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ\s]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sobrenome',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CPF',
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                          DateTextInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Data de Nascimento',
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: 'DD/MM/AAAA',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  cursorColor: Colors.black,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  cursorColor: Colors.black,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Repita sua senha',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                          !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue,) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }

    String formattedDate = '';
    if (digitsOnly.length >= 2) {
      formattedDate = digitsOnly.substring(0, 2);
      if (digitsOnly.length >= 4) {
        formattedDate += '/' + digitsOnly.substring(2, 4);
        if (digitsOnly.length > 4) {
          formattedDate += '/' + digitsOnly.substring(4);
        }
      } else if (digitsOnly.length > 2) {
        formattedDate += '/' + digitsOnly.substring(2);
      }
    } else {
      formattedDate = digitsOnly;
    }

    return TextEditingValue(
      text: formattedDate,
      selection: TextSelection.collapsed(offset: formattedDate.length),
    );
  }
}




