import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as sys;
import 'package:path/path.dart' as path;

class InputImage extends StatefulWidget {
  final void Function(File) setImage;

  const InputImage(this.setImage);

  @override
  InputImageState createState() => InputImageState();
}

class InputImageState extends State<InputImage> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
      final savedImage = await _pickedImage!.copy(
          '${(await sys.getApplicationDocumentsDirectory()).path}/${path.basename(_pickedImage!.path)}');
      widget.setImage(savedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                child: _pickedImage != null
                    ? Image.file(
                        _pickedImage!,
                        fit: BoxFit.cover,
                      )
                    : const Center(child: Text('Nenhuma imagem')),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Material(
              color: Theme.of(context).colorScheme.secondary,
              child: InkWell(
                onTap: _pickImage,
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
