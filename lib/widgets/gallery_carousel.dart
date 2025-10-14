import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../screens/image_screen.dart';

class GalleryCarousel extends StatelessWidget {
  final List<Photo?>? snapshot;
  const GalleryCarousel({
    super.key, required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: CarouselView(
          scrollDirection: Axis.vertical,
          itemExtent: double.infinity,
          // shrinkExtent: 200,
          padding: const EdgeInsets.all(10.0),
          onTap: (int index) {
            final photo = snapshot?[index];
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) =>
                    ImageScreen(imagePath: photo!.url),
              ),
            );
          },
          children: List.generate(snapshot!.length, (index) {
            final photo = snapshot![index];
            if (photo == null) {
              return const SizedBox.shrink();
            }
            return Stack(
              children: [
                InkWell(
                  splashColor: Colors.white10,
                  child: Ink.image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      photo.url,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Text(
                    snapshot![index]!.title,
                    style: TextStyle(
                      backgroundColor: Colors.black54,
                      color: Colors.white,
                      // fontSize: 22,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
