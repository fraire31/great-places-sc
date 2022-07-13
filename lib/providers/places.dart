import 'package:flutter/material.dart';

import '../helpers/location_helper.dart';
import '../models/place.dart';

class Places with ChangeNotifier {
  final List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  void addPlace(String title, PlaceLocation pickedLocation, image) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);

    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );

    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: updatedLocation,
    );

    _items.add(newPlace);
    notifyListeners();
  }
}
