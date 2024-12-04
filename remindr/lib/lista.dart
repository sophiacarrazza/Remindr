import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ListaDeCompras extends StatefulWidget {
  final bool showPopup;
  ListaDeCompras({
    this.showPopup = false,
    this.farmaciaItems = const [],
    this.shoppingItems = const [],
    this.supermercadoItems = const [],
  }); // valor padrão
  final List<String> farmaciaItems;
  final List<String> shoppingItems;
  final List<String> supermercadoItems;

  ListaDeCompras.named({
    required this.farmaciaItems,
    required this.shoppingItems,
    required this.supermercadoItems,
    this.showPopup = false,
  });

  @override
  _ListaDeComprasState createState() => _ListaDeComprasState();
}
class _ListaDeComprasState extends State<ListaDeCompras> {
  late List<String> farmaciaItems;
  late List<String> shoppingItems;
  late List<String> supermercadoItems;

  String _selectedCategory = 'Farmácia';
  final TextEditingController _itemController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _textSpoken = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    // Inicializa as listas recebidas
    farmaciaItems = List.from(widget.farmaciaItems);
    shoppingItems = List.from(widget.shoppingItems);
    supermercadoItems = List.from(widget.supermercadoItems);

    if (widget.showPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddItemDialog(context);
      });
    }
  }

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
            Navigator.pop(context, {
              'Farmácia': farmaciaItems,
              'Shopping': shoppingItems,
              'Supermercado': supermercadoItems,
            });
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

  void _showAddItemDialog(BuildContext context) {
    String localSelectedCategory = _selectedCategory;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Adicionar Item"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _itemController,
                    decoration: InputDecoration(labelText: "Nome do item"),
                  ),
                  SizedBox(height: 20),
                  IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: _isListening ? Colors.red : Colors.black,
                    ),
                    onPressed: _listen,
                  ),
                  DropdownButton<String>(
                    value: localSelectedCategory,
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Adicionar"),
              onPressed: () {
                setState(() {
                  _selectedCategory = localSelectedCategory;
                });
                _addItemToCategory();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
      _itemController.clear();
    }
  }

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
