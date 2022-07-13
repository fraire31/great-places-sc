import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  const ImageInput({Key? key, required this.onSelectImage}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  XFile? _imageTaken;

  Future<void> _onImageButtonPressed(
      ImageSource source, BuildContext? context) async {
    final ImagePicker _picker = ImagePicker();

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600,
      );

      if (pickedFile == null) {
        return;
      }

      setState(() {
        _imageTaken = pickedFile;
      });

      final appDir = await syspaths.getApplicationDocumentsDirectory();

      final fileName = path.basename(pickedFile.path);

      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      widget.onSelectImage(savedImage);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            alignment: Alignment.center,
            child: _imageTaken == null
                ? const Text(
                    'No Image Taken',
                    textAlign: TextAlign.center,
                  )
                : Image.file(
                    File(_imageTaken!.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )),
        const SizedBox(
          width: 10,
        ),
        // Expanded(
        //   child: TextButton.icon(
        //     icon: const Icon(
        //       Icons.camera,
        //     ),
        //     label: Text(
        //       'Pick a Picture',
        //       style: TextStyle(
        //         color: Theme.of(context).colorScheme.primary,
        //       ),
        //     ),
        //     onPressed: () {
        //       _onImageButtonPressed(
        //         ImageSource.gallery,
        //         context,
        //       );
        //     },
        //   ),
        // ),
        Expanded(
          child: TextButton.icon(
            icon: const Icon(
              Icons.camera,
            ),
            label: Text(
              'Take a Picture',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: () {
              _onImageButtonPressed(ImageSource.camera, context);
            },
          ),
        )
      ],
    );
  }
}
