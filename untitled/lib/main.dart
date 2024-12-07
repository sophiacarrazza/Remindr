import 'package:flutter/material.dart';
import 'lista.dart';
import 'login.dart';
import 'map_screen.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}

//tela estatica
class TelaBemVindo extends StatelessWidget {
  final String username;
  final int userId;

  TelaBemVindo({required this.username,required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove o botão de voltar
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Olá $username!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen())
                  );
                // Ação do botão de configurações
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bem vindo ao Remindr!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),

            ),
            SizedBox(height: 20),
            Text(
              'Clique no "+" para adicionar um item em sua lista ou em "☰" para visualizá-la.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()
                  ),
                );
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
                    builder: (context) => ListaDeCompras(userId: userId,username: username,),
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
                  builder: (context) => ListaDeCompras(userId: userId,username: username,),
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
    );
  }
}
