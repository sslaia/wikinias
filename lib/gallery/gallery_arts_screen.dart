import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/gallery_content_item.dart';
import '../services/app_data_service.dart';
import '../widgets/gallery_carousel.dart';

class GalleryArtsScreen extends StatefulWidget {
  const GalleryArtsScreen({super.key});

  @override
  State<GalleryArtsScreen> createState() => _GalleryArtsScreenState();
}

class _GalleryArtsScreenState extends State<GalleryArtsScreen> {
  late Future<List<GalleryContentItem>> futureArtsGallery;

  @override
  void initState() {
    super.initState();
    final appData = Provider.of<AppDataService>(context, listen: false);
    futureArtsGallery = appData.loadGalleryData(category: "arts");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GalleryContentItem>>(
      future: futureArtsGallery,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return snapshot.hasData
              ? GalleryCarousel(snapshot: snapshot.data)
              : const CircularProgressIndicator();
        }
      },
    );
  }
}
