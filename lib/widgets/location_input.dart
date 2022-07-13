import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  const LocationInput({Key? key, required this.onSelectPlace})
      : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMap = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    setState(() {
      _previewImageUrl = staticMap;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    final locationData = await Location().getLocation();
    _showPreview(locationData.latitude!, locationData.longitude!);
    widget.onSelectPlace(locationData.latitude, locationData.longitude);
  }

  Future<void> _selectOnMap() async {
    final locationData = await Location().getLocation().then((value) async {
      final selectedLocation = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => MapScreen(
            isSelecting: true,
            initialLocation: LatLng(value.latitude!, value.longitude!),
          ),
        ),
      );

      if (selectedLocation == null) {
        return;
      }

      _showPreview(selectedLocation.latitude, selectedLocation.longitude);
      widget.onSelectPlace(
          selectedLocation.latitude, selectedLocation.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? const Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              onPressed: () {
                _getCurrentUserLocation();
              },
              label: const Text('Current location'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              onPressed: () {
                _selectOnMap();
              },
              label: const Text('Select on map'),
            ),
          ],
        )
      ],
    );
  }
}
