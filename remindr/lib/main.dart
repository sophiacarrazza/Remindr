import 'package:flutter/material.dart';
import 'lista.dart'; // A tela de edição de listas
import 'login.dart';
import 'map_screen.dart';
import 'dart:math' as math;

void main() {
  runApp(MaterialApp(
    home: TelaBemVindo(),
  ));
}

class TelaBemVindo extends StatefulWidget {
  @override
  _TelaBemVindoState createState() => _TelaBemVindoState();
}

class _TelaBemVindoState extends State<TelaBemVindo> {
  // Listas de itens por categoria (no exemplo, itens já existentes)
  List<String> farmaciaItems = [];
  List<String> shoppingItems = [];
  List<String> supermercadoItems = [];

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
              'Olá Lívia!',
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
                    MaterialPageRoute(builder: (context) => Login())
                  );
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
            Text(
              'Clique no "📍" para visualizar o mapa ou em "☰" para adicionar ou editar um item em sua lista.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            // Aqui começa a visualização das listas
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  _buildCategoria('Farmácia', farmaciaItems),
                  _buildCategoria('Shopping', shoppingItems),
                  _buildCategoria('Supermercado', supermercadoItems),
                ],
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
              icon: Icon(Icons.location_on, size: 50),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => MapScreen(),
                    ),
                );
              },
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.menu, size: 50),
              color: Colors.white,
              onPressed: () {
                // Redireciona para a tela de edição das listas
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaDeCompras(
                      farmaciaItems: farmaciaItems,
                      shoppingItems: shoppingItems,
                      supermercadoItems: supermercadoItems,
                    ),
                  ),
                ).then((updatedItems) {
                  if (updatedItems != null) {
                    setState(() {
                      farmaciaItems = updatedItems['Farmácia'];
                      shoppingItems = updatedItems['Shopping'];
                      supermercadoItems = updatedItems['Supermercado'];
                    });
                  }
                });
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
                  builder: (context) => ListaDeCompras(
                    showPopup: true,
                    farmaciaItems: farmaciaItems,
                    shoppingItems: shoppingItems,
                    supermercadoItems: supermercadoItems,
                  ),
                ),
              ).then((updatedItems) {
                if (updatedItems != null) {
                  setState(() {
                    farmaciaItems = updatedItems['Farmácia'];
                    shoppingItems = updatedItems['Shopping'];
                    supermercadoItems = updatedItems['Supermercado'];
                  });
                }
              });
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

  // Função para construir a visualização das categorias de lista
  Widget _buildCategoria(String categoria, List<String> itens) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.category,
                color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1.0)),
            SizedBox(width: 10),
            Text(categoria),
          ],
        ),
        children: itens.map((item) {
          return ListTile(
            title: Text(item),
          );
        }).toList(),
      ),
    );
  }
}
