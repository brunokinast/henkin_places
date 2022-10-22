import 'package:flutter/material.dart';
import 'package:henkin_places/providers/places_provider.dart';
import 'package:henkin_places/views/map_screen.dart';
import 'package:henkin_places/views/place_detail_screen.dart';
import 'package:henkin_places/views/place_form_screen.dart';
import 'package:henkin_places/views/places_overview_screen.dart';
import 'package:henkin_places/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlacesProvider(),
      child: MaterialApp(
        title: 'Locais legais',
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            },
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.amber,
            accentColor: Colors.purple,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          AppRoutes.home: (_) => PlacesOverviewScreen(),
          AppRoutes.placeForm: (_) => PlaceFormScreen(),
          AppRoutes.map: (_) => MapScreen(),
          AppRoutes.placeDetail: (_) => PlaceDetailScreen(),
        },
      ),
    );
  }
}
