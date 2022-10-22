import 'package:flutter/material.dart';
import 'package:henkin_places/providers/places_provider.dart';
import 'package:henkin_places/utils/app_routes.dart';
import 'package:henkin_places/widgets/place_item.dart';
import 'package:provider/provider.dart';

class PlacesOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus locais'),
        centerTitle: true,
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final result =
                await Navigator.of(context).pushNamed(AppRoutes.placeForm);
            if (result != null) {
              messenger
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(result as String)));
            }
          },
        ),
      ),
      body: FutureBuilder(
        future: context.read<PlacesProvider>().loadPlaces(),
        builder: (_, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<PlacesProvider>(
                    builder: (_, places, __) => ListView.builder(
                      itemCount: places.placesCount,
                      itemBuilder: (_, i) => PlaceItem(places.places[i]),
                    ),
                  ),
      ),
    );
  }
}
