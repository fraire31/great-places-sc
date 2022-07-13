import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './firebase_options.dart';
import './providers/places.dart';
import './screens/add_place_screen.dart';
import './screens/place_detail_screen.dart';
import './screens/places_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Places(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Great Places',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.indigo,
            accentColor: Colors.amber,
          ),
        ),
        initialRoute: PlacesListScreen.screenId,
        routes: {
          AddPlaceScreen.screenId: (context) => const AddPlaceScreen(),
          PlacesListScreen.screenId: (context) => const PlacesListScreen(),
          PlaceDetailScreen.screenId: (context) => const PlaceDetailScreen()
        },
      ),
    );
  }
}
