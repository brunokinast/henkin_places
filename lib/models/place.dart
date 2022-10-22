import 'package:latlong2/latlong.dart';

class Place {
  final String id;
  final String title;
  final String imagePath;
  final LatLng location;
  final String address;

  Place(
    this.id, {
    required this.title,
    required this.imagePath,
    required this.location,
    required this.address,
  });
}
