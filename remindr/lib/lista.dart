import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MaterialApp(
    home: ListaDeCompras(),
  ));
}

class ListaDeCompras extends StatefulWidget {
  final bool showPopup;
  ListaDeCompras({this.showPopup = false}); // valor padrão

  @override
  _ListaDeComprasState createState() => _ListaDeComprasState();
}

class _ListaDeComprasState extends State<ListaDeCompras> {
  // Listas de itens por categoria
  List<String> farmaciaItems = [];
  List<String> shoppingItems = [];
  List<String> supermercadoItems = [];

  String _selectedCategory = 'Farmácia'; // Categoria selecionada inicialmente
  final TextEditingController _itemController = TextEditingController();

  // Variáveis para reconhecimento de voz
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _textSpoken = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    // Mostrar o diálogo se o parâmetro showPopup for verdadeiro
    if (widget.showPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddItemDialog(context);
      });
    }
  }

  // Função para iniciar ou parar o reconhecimento de voz
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _textSpoken = val.recognizedWords;
            _itemController.text = _textSpoken;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _itemController.clear();
      _textSpoken = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
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
              onPressed: () {},
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
              _showAddItemDialog(context);
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
    String localSelectedCategory = _selectedCategory; // Variável local para armazenar a categoria selecionada

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Adicionar Item"),
          content: StatefulBuilder(
            // Permite recriar o estado dentro do diálogo
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _itemController,
                    decoration: InputDecoration(labelText: "Nome do item"),
                  ),
                  SizedBox(height: 20),
                  // Botão para iniciar o reconhecimento de voz
                  IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: _isListening ? Colors.red : Colors.black,
                    ),
                    onPressed: _listen, // Inicia/parar o reconhecimento de voz

                  ),
                  DropdownButton<String>(
                    value: localSelectedCategory, // Valor local
                    onChanged: (String? newValue) {
                      setState(() {
                        localSelectedCategory = newValue!;
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
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                _itemController.clear();
                Navigator.of(context).pop(); // Fecha o popup
              },
            ),
            TextButton(
              child: Text("Adicionar"),
              onPressed: () {
                setState(() {
                  _selectedCategory = localSelectedCategory; // Atualiza a categoria global
                });
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
