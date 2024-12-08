import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentPosition;
  List<Marker> _markers = [];
  late MapController _mapController;
  late Database _database;
  Marker? _temporaryMarker; // Armazena o marcador temporário

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initDatabase();
    _getCurrentLocation();
    _loadSavedLocations(); // Carrega locais salvos ao iniciar
  }

  // Inicializa o banco de dados SQLite
  Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = Path.join(databasePath, 'locations.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            tag TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Salva um local no banco de dados
  Future<void> _saveLocation(LatLng point, String tag) async {
    await _database.insert(
      'locations',
      {'latitude': point.latitude, 'longitude': point.longitude, 'tag': tag},
    );
    print('Local salvo: $point com a tag $tag');
  }

  // Carrega os locais salvos do banco de dados
  Future<void> _loadSavedLocations() async {
    final List<Map<String, dynamic>> savedLocations =
        await _database.query('locations');

    setState(() {
      for (var location in savedLocations) {
        final LatLng point =
            LatLng(location['latitude'], location['longitude']);
        final String tag = location['tag'];

        // Adiciona os marcadores salvos à lista com tooltip da tag
        _markers.add(
          Marker(
            point: point,
            width: 40.0,
            height: 40.0,
            child: Tooltip(
              message: tag,
              child: const Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 244, 54, 89),
                size: 40.0,
              ),
            ),
          ),
        );
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('O serviço de localização está desativado.')),
        );
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de localização negada.')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de localização permanentemente negada.')),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Erro ao obter localização: $e');
    }
  }

  Future<void> _showTagPopup(BuildContext context, LatLng point) async {
    // Adiciona um marcador temporário com o ícone "+" verde
    setState(() {
      _temporaryMarker = Marker(
        point: point,
        width: 40.0,
        height: 40.0,
        child: const Icon(
          Icons.add_circle,
          color: Color.fromARGB(255, 74, 168, 151), // Verde para marcador temporário
          size: 40.0,
        ),
      );
    });

    String? selectedTag = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Tamanho da tela
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            // Tamanho fixo do popup
            const double popupWidth = 300.0;
            const double popupHeight = 1000.0;

            // Cálculo da posição central
            final double topPosition = (screenHeight / 2) - (popupHeight / 2);
            final double leftPosition = (screenWidth / 2) - (popupWidth / 2);

            return Stack(
              children: [
                Positioned(
                  top: topPosition,
                  left: leftPosition,
                  child: Container(
                    width: popupWidth,
                    height: popupHeight,
                    child: AlertDialog(
                      title: const Text('Escolha uma tag'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Supermercado'),
                            onTap: () => Navigator.pop(context, 'Supermercado'),
                          ),
                          ListTile(
                            title: const Text('Farmácia'),
                            onTap: () => Navigator.pop(context, 'Farmácia'),
                          ),
                          ListTile(
                            title: const Text('Shopping'),
                            onTap: () => Navigator.pop(context, 'Shopping'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedTag != null) {
      setState(() {
        // Remove o marcador temporário e adiciona o marcador vermelho com a tag selecionada
        if (_temporaryMarker != null) {
          _markers.remove(_temporaryMarker);
          _temporaryMarker = null;
        }
        _markers.add(
          Marker(
            point: point,
            width: 40.0,
            height: 40.0,
            child: Tooltip(
              message: selectedTag,
              child: const Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 244, 54, 89), // Vermelho para marcador salvo
                size: 40.0,
              ),
            ),
          ),
        );
      });

      // Salva o local no banco de dados
      await _saveLocation(point, selectedTag);
    } else {
      // Remove o marcador temporário se nenhuma tag for selecionada
      setState(() {
        if (_temporaryMarker != null) {
          _markers.remove(_temporaryMarker);
          _temporaryMarker = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Localização'),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                crs: const Epsg3857(),
                initialCenter:
                    _currentPosition ?? const LatLng(-15.7801, -47.9292),
                maxZoom: 18.0,
                onTap: (tapPosition, point) async {
                  await _showTagPopup(context, point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: [
                  ..._markers,
                  if (_temporaryMarker != null) _temporaryMarker!,
                  if (_currentPosition != null)
                    Marker(
                      point: _currentPosition!,
                      width: 40.0,
                      height: 40.0,
                      child: const Icon(
                        Icons.location_pin,
                        color:
                            Color.fromARGB(255, 30, 121, 196), // Ícone da posição atual
                        size: 40.0,
                      ),
                    ),
                ]),
              ],
            ),
    );
  }
}