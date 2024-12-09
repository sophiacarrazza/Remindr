import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('projeto.db');
    return _database!;
  }

  //iniciar o banco de dados
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  //criaçao de ambas as tabelas
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
    await db.execute('''
    CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER,
      productName TEXT NOT NULL,
      productClass TEXT CHECK(productClass IN ('Farmácia','Supermercado','Shopping')),
      FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
    )
  ''');
    await db.execute('''
    CREATE TABLE locations (
            userId INTEGER,
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            tag TEXT NOT NULL
          )
  ''');

  }
  Future<int> registerUser(String username, String password) async {
    final db = await instance.database;
    return await db.insert('users', {'username': username, 'password': password});
  }

  Future<int> registerProduct(String productName,String productClass, int userId) async {
    final db = await instance.database;
    return await db.insert('products', {'userId': userId, 'productName': productName, 'productClass': productClass});
  }

  Future<int> registerLocation(int userId, double latitude, double longitude, String tag) async {
    final db = await database;
    final Map<String, dynamic> location = {
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'tag': tag
    };

    // Insere o local na tabela 'locations'
    return await db.insert('locations', location);
  }

  Future<List<Map<String, dynamic>>> getLocationsByUserId(int userId) async {
    final db = await instance.database;

    // Consulta as localizações associadas ao userId
    return await db.query(
      'locations',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<String?> getTagByCoordinates(
      int userId, double latitude, double longitude) async {
    final db = await instance.database;

    // Consulta para buscar a tag do ponto
    var result = await db.query(
      'locations',
      columns: ['tag'], // Seleciona apenas a coluna 'tag'
      where: 'userId = ? AND latitude = ? AND longitude = ?',
      whereArgs: [userId, latitude, longitude],
    );

    // Verifica se encontrou algum registro e retorna a tag
    if (result.isNotEmpty) {
      return result.first['tag'] as String?;  // Retorna a tag do primeiro (único) resultado
    } else {
      return null;  // Retorna null caso não encontre o ponto
    }
  }
  Future<int> deleteLocationByCoordinates(int userId, double latitude, double longitude) async {
    final db = await instance.database;

    // Deleta a localização com base no userId, latitude e longitude
    return await db.delete(
      'locations',
      where: 'userId = ? AND latitude = ? AND longitude = ?',
      whereArgs: [userId, latitude, longitude],
    );
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      columns: ['id', 'username', 'password'], // Defina as colunas que você quer retornar
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<void> printAllUsers() async {
    final db = await instance.database;
    final users = await db.query('users');

    if (users.isEmpty) {
      print('Nenhum usuário cadastrado.');
    } else {
      print('Usuários cadastrados:');
      for (var user in users) {
        print('ID: ${user['id']}, Nome: ${user['username']}, Senha: ${user['password']}');
      }
    }
  }

  Future<void> printAllProducts() async {
    final db = await instance.database;
    final products = await db.query('products');

    if (products.isEmpty) {
      print('Nenhum produto cadastrado.');
    } else {
      print('Produtos cadastrados:');
      for (var product in products) {
        print('ID: ${product['userId']}, Nome: ${product['productName']}, Classe: ${product['productClass']}');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllProducts(int userId) async {
    final db = await instance.database;
    return await db.query(
      'products',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<int?> getProductId(int userId, String productName) async {
    final db = await instance.database;
    final result = await db.query(
      'products',
      columns: ['id'], // Define para retornar apenas a coluna 'id'
      where: 'userId = ? AND productName = ?',
      whereArgs: [userId, productName],
      limit: 1, // Limita a busca a um único resultado
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null; // Retorna null se nenhum produto for encontrado
    }
  }


  Future<int> deleteProduct(int productId) async {
    final db = await instance.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );
  }



  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
