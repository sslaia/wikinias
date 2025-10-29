import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/gallery_content_item.dart';
import '../services/app_data_service.dart';
import '../widgets/gallery_carousel.dart';

class GalleryDancesScreen extends StatefulWidget {
  const GalleryDancesScreen({super.key});

  @override
  State<GalleryDancesScreen> createState() => _GalleryDancesScreenState();
}

class _GalleryDancesScreenState extends State<GalleryDancesScreen> {
  late Future<List<GalleryContentItem>> futureDancesGallery;

  @override
  void initState() {
    super.initState();
    final appData = Provider.of<AppDataService>(context, listen: false);
    futureDancesGallery = appData.loadGalleryData(category: "dances");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GalleryContentItem>>(
      future: futureDancesGallery,
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
