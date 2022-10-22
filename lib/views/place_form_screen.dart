import 'dart:io';
import 'package:flutter/material.dart';
import 'package:henkin_places/models/place.dart';
import 'package:henkin_places/providers/places_provider.dart';
import 'package:henkin_places/widgets/image_picker.dart';
import 'package:henkin_places/widgets/location_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class PlaceFormScreen extends StatefulWidget {
  @override
  PlaceFormScreenState createState() => PlaceFormScreenState();
}

class PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  File? _imageFile;
  LatLng? _location;
  bool _titleError = false;
  bool _imageError = false;
  bool _locationError = false;
  bool _isSaving = false;

  Future<void> _submit() async {
    if (!_isSaving) {
      setState(() {
        _isSaving = true;
        _titleError = _titleController.text.trim().isEmpty;
        _imageError = _imageFile == null;
        _locationError = _location == null;
      });
      try {
        final navigator = Navigator.of(context);

        if (!_titleError && !_imageError && !_locationError) {
          await context.read<PlacesProvider>().addPlace(Place(
                UniqueKey().toString(),
                title: _titleController.text,
                imagePath: _imageFile!.path,
                location: _location!,
                address: '',
              ));
          navigator.pop('Local adicionado!');
        }
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  _setImage(File image) {
    _imageFile = image;
  }

  _setLocation(LatLng location) {
    _location = location;
  }

  Widget customError(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style: Theme.of(context).textTheme.caption!.copyWith(
              color: Theme.of(context).errorColor,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar local'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        child: _isSaving
            ? const CircularProgressIndicator()
            : const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 20,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Título',
                  errorText: _titleError ? 'Informe um título' : null,
                ),
                controller: _titleController,
              ),
            ),
            InputImage(_setImage),
            if (_imageError) customError('Adicione uma imagem'),
            LocationPicker(_setLocation),
            if (_locationError) customError('Adicione uma localização'),
          ],
        ),
      ),
    );
  }
}
