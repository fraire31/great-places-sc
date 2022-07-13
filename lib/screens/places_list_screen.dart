import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import '../providers/places.dart';
import '../screens/place_detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  static const String screenId = 'place-list-screen';
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddPlaceScreen.screenId);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<Places>(
        builder: (context, places, child) => places.items.length <= 0
            ? child!
            : ListView.builder(
                itemCount: places.items.length,
                itemBuilder: (context, i) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(places.items[i].image),
                  ),
                  title: Text(places.items[i].title),
                  subtitle: Text(places.items[i].location!.address!),
                  onTap: () {
                    Navigator.of(context).pushNamed(PlaceDetailScreen.screenId,
                        arguments: places.items[i].id);
                  },
                ),
              ),
        child: const Center(
          child: Text(
            'No places yet',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
