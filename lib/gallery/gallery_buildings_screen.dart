import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/models/gallery_content_item.dart';
import 'package:wikinias/services/app_data_service.dart';

import '../widgets/gallery_carousel.dart';

class GalleryBuildingsScreen extends StatefulWidget {
  const GalleryBuildingsScreen({super.key});

  @override
  State<GalleryBuildingsScreen> createState() => _GalleryBuildingsScreenState();
}

class _GalleryBuildingsScreenState extends State<GalleryBuildingsScreen> {
  late Future<List<GalleryContentItem>> futureBuildingsGallery;

  @override
  void initState() {
    super.initState();
    final appData = Provider.of<AppDataService>(context, listen: false);
    futureBuildingsGallery = appData.loadGalleryData(category: "buildings");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GalleryContentItem>>(
      future: futureBuildingsGallery,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No photos found in this category."));
        } else {
          return snapshot.hasData
              ? GalleryCarousel(snapshot: snapshot.data)
              : const CircularProgressIndicator();
        }
      },
    );
  }
}
