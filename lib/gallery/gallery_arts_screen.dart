import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../services/photo_api_service.dart';
import '../widgets/gallery_carousel.dart';

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
            ? GalleryCarousel(snapshot: snapshot.data)
            : const CircularProgressIndicator();
      },
    );
  }
}
