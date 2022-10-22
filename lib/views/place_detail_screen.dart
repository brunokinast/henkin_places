import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:henkin_places/models/place.dart';
import 'package:henkin_places/providers/places_provider.dart';
import 'package:henkin_places/widgets/location_picker.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Place place = ModalRoute.of(context)!.settings.arguments as Place;
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              if ((await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  content:
                      const Text('Tem certeza que deseja remover esse local?'),
                  actions: [
                    TextButton(
                      child: const Text('Sim'),
                      onPressed: () => Navigator.of(ctx).pop(true),
                    ),
                    TextButton(
                      child: const Text('Não'),
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                  ],
                ),
              ))!) {
                unawaited(context.read<PlacesProvider>().removePlace(place));
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.file(File(place.imagePath)),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  place.address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            LocationPicker(null, place.location),
          ],
        ),
      ),
    );
  }
}
