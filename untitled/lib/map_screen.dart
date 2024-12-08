import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'db.dart';

class MapScreen extends StatefulWidget {
  final int userId; // Recebe o ID do usuário

  const MapScreen({super.key, required this.userId});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentPosition;
  List<Marker> _markers = [];
  late MapController _mapController;
  Marker? _temporaryMarker; // Armazena o marcador temporário
  Marker? _searchMarker; // Armazena o marcador de pesquisa atual
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
    _loadSavedLocations(widget.userId); // Carrega locais salvos ao iniciar
  }

  // Salva um local no banco de dados
  Future<void> _saveLocation(LatLng point, String tag) async {
    final userId = widget.userId;
    await DatabaseHelper.instance.registerLocation(
        userId,
        point.latitude,
        point.longitude,
        tag
    );
  }

  // Carrega os locais salvos do banco de dados com base no userId
  Future<void> _loadSavedLocations(int userId) async {
    try {
      final List<Map<String, dynamic>> savedLocations = await DatabaseHelper.instance.getLocationsByUserId(userId);

      setState(() {
        _markers.clear(); // Limpa os marcadores anteriores
        for (var location in savedLocations) {
          final LatLng point = LatLng(location['latitude'], location['longitude']);
          final String tag = location['tag'];

          // Adiciona os marcadores filtrados à lista com tooltip da tag
          _markers.add(
            Marker(
              point: point,
              width: 40.0,
              height: 40.0,
              child: GestureDetector(
                onTap: () => _showDeletePopup(context, point), // Popup para deletar
                child: Tooltip(
                  message: tag,
                  child: const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 244, 54, 89), // Vermelho para salvo
                    size: 40.0,
                  ),
                ),
              ),
            ),
          );
        }
      });
    } catch (e) {
      print('Erro ao carregar as localizações: $e');
    }
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

  // Exibe popup para selecionar uma tag e adicionar um marcador
  Future<void> _showTagPopup(BuildContext context, LatLng point) async {
    setState(() {
      // Adiciona um marcador temporário com o ícone verde "+"
      _temporaryMarker = Marker(
        point: point,
        width: 40.0,
        height: 40.0,
        child: const Icon(
          Icons.add_circle,
          color: Color.fromARGB(255, 74, 168, 151),
          size: 40.0,
        ),
      );
    });

    String? selectedTag = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Escolha uma tag"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Supermercado"),
              onTap: () => Navigator.pop(context, "Supermercado"),
            ),
            ListTile(
              title: const Text("Farmácia"),
              onTap: () => Navigator.pop(context, "Farmácia"),
            ),
            ListTile(
              title: const Text("Shopping"),
              onTap: () => Navigator.pop(context, "Shopping"),
            ),
          ],
        ),
      ),
    );

    if (selectedTag != null) {
      setState(() {
        if (_temporaryMarker != null) {
          _markers.remove(_temporaryMarker);
          _temporaryMarker = null;
        }
        // Adiciona o marcador salvo com a tag selecionada
        _markers.add(Marker(
          point: point,
          width: 40.0,
          height: 40.0,
          child: Tooltip(
            message: selectedTag,
            child: GestureDetector(
              onTap: () => _showDeletePopup(context, point),
              child: const Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 244, 54, 89),
                size: 40.0,
              ),
            ),
          ),
        ));
      });
      await _saveLocation(point, selectedTag);
    } else {
      setState(() {
        if (_temporaryMarker != null) {
          _markers.remove(_temporaryMarker);
          _temporaryMarker = null;
        }
      });
    }
  }

  // Exibe popup para confirmar a exclusão do marcador salvo
  Future<void> _showDeletePopup(BuildContext context, LatLng point) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Excluir marcador"),
        content:
        const Text("Você deseja excluir este marcador permanentemente?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Excluir")),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() {
        // Remove o marcador da lista e do banco de dados
        _markers.removeWhere((marker) => marker.point == point);
      });

      await DatabaseHelper.instance.deleteLocationByCoordinates(
        widget.userId,
        point.latitude,
        point.longitude,
      );

      print("Marcador excluído em $point");
    }
  }

  // Função para buscar locais usando a API do Nominatim
  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> results = jsonDecode(response.body);

        if (results.isNotEmpty) {
          final double lat = double.parse(results[0]['lat']);
          final double lon = double.parse(results[0]['lon']);

          setState(() {
            // Remove o marcador de pesquisa anterior
            if (_searchMarker != null) {
              _markers.remove(_searchMarker);
            }

            // Adiciona o novo marcador de pesquisa
            final newSearchMarker = Marker(
              point: LatLng(lat, lon),
              width: 40.0,
              height: 40.0,
              child: const Icon(Icons.location_on, color: Color.fromARGB(255, 227, 112, 4), size: 40.0),
            );

            _searchMarker = newSearchMarker;
            _markers.add(newSearchMarker);

            // Centraliza o mapa na localização encontrada
            _mapController.move(LatLng(lat, lon), 15.0);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nenhum resultado encontrado')));
        }
      } else {
        throw Exception('Erro ao buscar localização');
      }
    } catch (e) {
      print('Erro na pesquisa de localização $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: "Buscar local...",
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _searchLocation(_searchController.text),
            ),
          ),
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) => _searchLocation(value),
        ),
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
            await _showTagPopup(context, point); // Popup para selecionar tag
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