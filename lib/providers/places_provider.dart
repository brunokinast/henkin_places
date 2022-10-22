import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:henkin_places/models/place.dart';
import 'package:henkin_places/utils/db_utils.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places => [..._places];
  int get placesCount => _places.length;

  Future<String> _getAddress(LatLng location) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse.php?lat=${location.latitude}&lon=${location.longitude}&format=jsonv2'));
    return json.decode(response.body)['display_name'] as String;
  }

  Future<void> addPlace(Place place) async {
    final address = await _getAddress(place.location);
    _places.add(Place(
      place.id,
      title: place.title,
      imagePath: place.imagePath,
      location: place.location,
      address: address,
    ));
    notifyListeners();
    await DBUtil.insert('PLACES', {
      'ID': place.id,
      'TITLE': place.title,
      'IMAGEPATH': place.imagePath,
      'LAT': place.location.latitude,
      'LNG': place.location.longitude,
      'ADDRESS': address,
    });
  }

  Future<void> removePlace(Place place) async {
    _places.remove(place);
    notifyListeners();
    await DBUtil.delete('PLACES', place.id);
  }

  Future<void> loadPlaces() async {
    _places = ((await DBUtil.select('PLACES')).map((map) => Place(
          map['ID'] as String,
          title: map['TITLE'] as String,
          imagePath: map['IMAGEPATH'] as String,
          location: LatLng(map['LAT'] as double, map['LNG'] as double),
          address: map['ADDRESS'] as String,
        ))).toList();
    notifyListeners();
  }
}
