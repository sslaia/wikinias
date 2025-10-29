import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/models/gallery_content_item.dart';
import 'package:wikinias/services/app_data_service.dart';

import '../widgets/gallery_carousel.dart';

class GalleryOthersScreen extends StatefulWidget {
  const GalleryOthersScreen({super.key});

  @override
  State<GalleryOthersScreen> createState() => _GalleryOthersScreenState();
}

class _GalleryOthersScreenState extends State<GalleryOthersScreen> {
  late Future<List<GalleryContentItem>> futureOthersGallery;

  @override
  void initState() {
    super.initState();
    final appData = Provider.of<AppDataService>(context, listen: false);
    futureOthersGallery = appData.loadGalleryData(category: "various");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GalleryContentItem>>(
      future: futureOthersGallery,
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
