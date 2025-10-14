import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../screens/image_screen.dart';
import '../services/photo_api_service.dart';
import '../widgets/gallery_carousel.dart';

class GalleryBuildingsScreen extends StatefulWidget {
  const GalleryBuildingsScreen({super.key});

  @override
  State<GalleryBuildingsScreen> createState() => _GalleryBuildingsScreenState();
}

class _GalleryBuildingsScreenState extends State<GalleryBuildingsScreen> {
  late Future<List<Photo?>> _futurePhotos;
  final PhotoApiService _photoApiService = PhotoApiService();

  @override
  void initState() {
    super.initState();
    _futurePhotos = _photoApiService.fetchBuildingPhotos();
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
