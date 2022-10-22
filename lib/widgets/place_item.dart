import 'dart:io';

import 'package:flutter/material.dart';
import 'package:henkin_places/models/place.dart';
import 'package:henkin_places/utils/app_routes.dart';
import 'package:parallax_image/parallax_image.dart';

class PlaceItem extends StatelessWidget {
  final Place place;

  const PlaceItem(this.place);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(AppRoutes.placeDetail, arguments: place),
      child: Card(
        elevation: 10,
        child: ParallaxImage(
          image: FileImage(File(place.imagePath)),
          extent: 150,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.6),
                  Color.fromRGBO(0, 0, 0, 0),
                ],
              ),
            ),
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: Column(
                children: [
                  Text(
                    place.title,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    place.address,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.white,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
