import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng? _selectedPos;

  Future<LatLng> getLatLang() async {
    final location = await Location().getLocation();
    return LatLng(location.latitude!, location.longitude!);
  }

  @override
  Widget build(BuildContext context) {
    final LatLng? placeLocation =
        ModalRoute.of(context)?.settings.arguments as LatLng?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        centerTitle: true,
      ),
      floatingActionButton: _selectedPos == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedPos);
              },
              child: const Icon(Icons.send),
            ),
      body: FutureBuilder<LatLng>(
        future: getLatLang(),
        builder: (_, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          return FlutterMap(
            options: MapOptions(
              center: placeLocation ?? snap.data,
              zoom: 17,
              onTap: placeLocation != null
                  ? null
                  : (_, pos) => setState(() => _selectedPos = pos),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: snap.data!,
                    builder: (_) => Stack(
                      alignment: Alignment.center,
                      children: const [
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 30,
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  if (_selectedPos != null || placeLocation != null)
                    Marker(
                      point:
                          _selectedPos != null ? _selectedPos! : placeLocation!,
                      builder: (_) => Stack(
                        clipBehavior: Clip.none,
                        children: const [
                          Positioned(
                            bottom: 10,
                            right: -7,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
