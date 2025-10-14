import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../services/photo_api_service.dart';
import '../widgets/gallery_carousel.dart';

class GalleryDancesScreen extends StatefulWidget {
  const GalleryDancesScreen({super.key});

  @override
  State<GalleryDancesScreen> createState() => _GalleryDancesScreenState();
}

class _GalleryDancesScreenState extends State<GalleryDancesScreen> {
  late Future<List<Photo?>> _futurePhotos;
  final PhotoApiService _photoApiService = PhotoApiService();

  @override
  void initState() {
    super.initState();
    _futurePhotos = _photoApiService.fetchDancePhotos();
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
