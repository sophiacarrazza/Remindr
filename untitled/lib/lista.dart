import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'db.dart';
import 'login.dart';
import 'map_screen.dart';

void main() {
  runApp(MaterialApp(
    home: ListaDeCompras(userId: -1,username: 'a',), // Passa o nome de usuário aqui
  ));
}

class ListaDeCompras extends StatefulWidget {
  final String username;
  final bool showPopup;
  final int userId; // Adicionando o campo username

  const ListaDeCompras({super.key, this.showPopup = false, required this.userId,required this.username});

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
    _fetchProducts(); // Recupera os produtos do banco de dados ao inicializar

    // Mostrar o diálogo se o parâmetro showPopup for verdadeiro
    if (widget.showPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddItemDialog(context);
      });
    }
  }

  // Função para buscar produtos do banco de dados
  Future<void> _fetchProducts() async {
    List<Map<String, dynamic>> products = await DatabaseHelper.instance.getAllProducts
      (widget.userId); // Altere conforme necessário

    // Organiza produtos nas listas apropriadas
    setState(() {
      for (var product in products) {
        String category = product['productClass'];
        String name = product['productName'];
        if (category == 'Farmácia') {
          farmaciaItems.add(name);
        } else if (category == 'Shopping') {
          shoppingItems.add(name);
        } else if (category == 'Supermercado') {
          supermercadoItems.add(name);
        }
      }
    });
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Olá ${widget.username}!',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          _buildCategoria('Farmácia', farmaciaItems),
          _buildCategoria('Shopping', shoppingItems),
          _buildCategoria('Supermercado', supermercadoItems),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xFF344955),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 50),
            IconButton(
              icon: const Icon(Icons.map, size: 50),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen(userId: widget.userId,)
                  ),
                );
              },
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.logout, size: 50),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
            ),
            const SizedBox(width: 50),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 90.0,
        width: 90.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              _showAddItemDialog(context);
            },
            shape: const StadiumBorder(),
            backgroundColor: const Color(0xFFF9AA33),
            child: Icon(Icons.add, size: 40, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCategoria(String categoria, List<String> itens) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              Icon(Icons.category,
                  color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(1.0)),
              const SizedBox(width: 10),
              Text(categoria),
            ],
          ),
          children: itens.asMap().entries.map((entry) {
            int index = entry.key;
            String item = entry.value;
            return ListTile(
              title: Text(item),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteItem(categoria, index);
                },
              ),
            );
          }).toList(),
        ),
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
          title: const Text("Adicionar Item"),
          content: StatefulBuilder(
            // Permite recriar o estado dentro do diálogo
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(labelText: "Nome do item"),
                  ),
                  const SizedBox(height: 20),
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
              child: const Text("Cancelar"),
              onPressed: () {
                _itemController.clear();
                Navigator.of(context).pop(); // Fecha o popup
              },
            ),
            TextButton(
              child: const Text("Adicionar"),
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
      DatabaseHelper.instance.registerProduct(itemName, _selectedCategory, widget.userId);
      DatabaseHelper.instance.printAllProducts();
      _itemController.clear();
      setState(() {});
    }
  }

  Future<void> _deleteItem(String categoria, int index) async {
    String itemName;

    // Determina o nome do item baseado na categoria e índice
    if (categoria == 'Farmácia') {
      itemName = farmaciaItems[index];
    } else if (categoria == 'Shopping') {
      itemName = shoppingItems[index];
    } else {
      itemName = supermercadoItems[index];
    }

    // Obtém o ID do produto
    final idP = await DatabaseHelper.instance.getProductId(widget.userId, itemName);

    // Verifica se o ID foi encontrado antes de deletar
    if (idP != null) {
      await DatabaseHelper.instance.deleteProduct(idP);

      // Atualiza a lista na interface após a exclusão
      setState(() {
        if (categoria == 'Farmácia') {
          farmaciaItems.removeAt(index);
        } else if (categoria == 'Shopping') {
          shoppingItems.removeAt(index);
        } else if (categoria == 'Supermercado') {
          supermercadoItems.removeAt(index);
        }
      });
    } else {
      print("Produto não encontrado para exclusão.");
    }
    DatabaseHelper.instance.printAllProducts();
  }

}