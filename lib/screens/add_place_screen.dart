import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';
import '../providers/places.dart';
import '../widgets/image_input.dart';
import '../widgets/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const String screenId = 'add-place-screen';
  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _form = GlobalKey<FormState>();
  String? _title;
  PlaceLocation? _pickedLocation;

  File? _pickedImage;

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace() {
    if (_title == null || _pickedImage == null || _pickedLocation == null) {
      return;
    }

    Provider.of<Places>(context, listen: false)
        .addPlace(_title!, _pickedLocation!, _pickedImage);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Place')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (value) {
                              _title = value;
                            },
                            decoration:
                                const InputDecoration(labelText: 'title'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ImageInput(onSelectImage: _selectImage),
                          const SizedBox(
                            height: 10,
                          ),
                          LocationInput(onSelectPlace: _selectPlace),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextButton.icon(
            label: const Text(
              'Add Place',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              _savePlace();
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              padding: Platform.isIOS
                  ? MaterialStateProperty.all(
                      const EdgeInsets.only(bottom: 25, top: 10.0))
                  : null,
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
