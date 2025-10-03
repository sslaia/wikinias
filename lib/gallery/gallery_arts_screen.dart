import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../services/photo_api_service.dart';

class GalleryArtsScreen extends StatefulWidget {
  const GalleryArtsScreen({super.key});

  @override
  State<GalleryArtsScreen> createState() => _GalleryArtsScreenState();
}

class _GalleryArtsScreenState extends State<GalleryArtsScreen> {
  late Future<List<Photo?>> _futurePhotos;
  final PhotoApiService _photoApiService = PhotoApiService();

  @override
  void initState() {
    super.initState();
    _futurePhotos = _photoApiService.fetchArtPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Photo?>>(
      future: _futurePhotos,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return snapshot.hasData
            ? Directionality(
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
                    children: List.generate(snapshot.data!.length, (index) {
                      final photo = snapshot.data![index];
                      if (photo == null) {
                        return const SizedBox.shrink();
                      }
                      return Stack(
                        children: [
                          Image.network(
                            photo.url,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Text('Image not available'));
                            },
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Text(
                              snapshot.data![index]!.title,
                              style: TextStyle(
                                backgroundColor: Colors.black54,
                                color: Colors.white,
                                fontSize: 22,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              )
            : const CircularProgressIndicator();
      },
    );
  }
}
