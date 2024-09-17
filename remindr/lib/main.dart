import 'package:flutter/material.dart';
import 'dart:math' as math;
void main() {
  runApp(MaterialApp(
    home: ListaDeCompras(),
  ));
}

class ListaDeCompras extends StatefulWidget {
  @override
  _ListaDeComprasState createState() => _ListaDeComprasState();
}

class _ListaDeComprasState extends State<ListaDeCompras> {
  // Listas de itens por categoria
  List<String> farmaciaItems = [];
  List<String> shoppingItems = [];
  List<String> supermercadoItems = [];

  String _selectedCategory = 'Farmácia'; // Categoria selecionada inicialmente
  final TextEditingController _itemController = TextEditingController(); // Controlador para o nome do item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Ação do botão de voltar
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          _buildCategoria('Farmácia', farmaciaItems),
          _buildCategoria('Shopping', shoppingItems),
          _buildCategoria('Supermercado', supermercadoItems),
        ],
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
                // Ação do botão Home
              },
            ),
            IconButton(
              icon: Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                // Ação do botão Menu
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context);
        },
        child: Icon(Icons.add, size: 40, color: Colors.white),
        shape: StadiumBorder(),
        backgroundColor: Color(0xFFF9AA33),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCategoria(String categoria, List<String> itens) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.category, color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)),
            SizedBox(width: 10),
            Text(categoria),
          ],
        ),
        children: itens.asMap().entries.map((entry) {
          int index = entry.key;
          String item = entry.value;
          return ListTile(
            title: Text(item),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteItem(categoria, index);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // Função para mostrar o popup de adicionar item
  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Adicionar Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _itemController,
                decoration: InputDecoration(labelText: "Nome do item"),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: <String>['Farmácia', 'Shopping', 'Supermercado']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o popup
              },
            ),
            TextButton(
              child: Text("Adicionar"),
              onPressed: () {
                _addItemToCategory();
                Navigator.of(context).pop(); // Fecha o popup
              },
            ),
          ],
        );
      },
    );
  }

  // Função para adicionar o item na categoria correta
  void _addItemToCategory() {
    String itemName = _itemController.text;

    if (itemName.isNotEmpty) {
      setState(() {
        if (_selectedCategory == 'Farmácia') {
          farmaciaItems.add(itemName);
        } else if (_selectedCategory == 'Shopping') {
          shoppingItems.add(itemName);
        } else if (_selectedCategory == 'Supermercado') {
          supermercadoItems.add(itemName);
        }
      });
      _itemController.clear(); // Limpa o campo de texto após adicionar
    }
  }

  // Função para deletar o item da categoria correta
  void _deleteItem(String categoria, int index) {
    setState(() {
      if (categoria == 'Farmácia') {
        farmaciaItems.removeAt(index);
      } else if (categoria == 'Shopping') {
        shoppingItems.removeAt(index);
      } else if (categoria == 'Supermercado') {
        supermercadoItems.removeAt(index);
      }
    });
  }
}
