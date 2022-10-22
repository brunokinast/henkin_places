import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:henkin_places/utils/app_routes.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationPicker extends StatefulWidget {
  final void Function(LatLng)? setLocation;
  final LatLng? placeLocation;

  const LocationPicker([this.setLocation, this.placeLocation]);

  @override
  LocationPickerState createState() => LocationPickerState();
}

class LocationPickerState extends State<LocationPicker> {
  static const apiKey = 'XXXXXXXXXXXXXXXXXXXXXX';
  String? _mapUrl;
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    if (widget.placeLocation != null) _updateMap(widget.placeLocation!);
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    LocationData location = await Location().getLocation();
    _updateMap(LatLng(location.latitude!, location.longitude!));
    setState(() => _isLoading = false);
  }

  Future<void> _selectMap() async {
    final result = await Navigator.of(context)
        .pushNamed(AppRoutes.map, arguments: widget.placeLocation);
    if (result != null) {
      _updateMap(result as LatLng);
    }
  }

  void _updateMap(LatLng location) {
    if (widget.setLocation != null) widget.setLocation!(location);
    setState(() => _mapUrl =
        'https://maps.geoapify.com/v1/staticmap?style=osm-bright&width=600&height=337&center=lonlat:${location.longitude},${location.latitude}&marker=lonlat:${location.longitude},${location.latitude};color:%23ff0000;size:medium&zoom=17&apiKey=$apiKey');
  }

  Container _blankContainer(Widget child) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.placeLocation != null ? 0 : 10),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _mapUrl != null && !_isLoading
                ? CachedNetworkImage(
                    imageUrl: _mapUrl!,
                    placeholder: (_, __) =>
                        _blankContainer(const CircularProgressIndicator()),
                  )
                : _blankContainer(_isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Nenhum local selecionado',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
          ),
          Row(
            children: [
              if (widget.placeLocation == null)
                MapIconButton('Localização atual', Icons.location_on,
                    _getCurrentLocation),
              MapIconButton(
                  '${widget.placeLocation != null ? 'Ver' : 'Selecionar'} no mapa',
                  Icons.map,
                  _selectMap),
            ],
          )
        ],
      ),
    );
  }
}

class MapIconButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;

  const MapIconButton(this.title, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Theme.of(context).colorScheme.secondary,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
