import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    final double bodyFontSize =
        Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'image_viewer',
          style: TextStyle(color: color, fontSize: bodyFontSize * 1.0),
        ).tr(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              InteractiveViewer(
                boundaryMargin: EdgeInsets.zero,
                minScale: 0.5,
                maxScale: 3.0,
                child: Image.network(
                  imagePath,
                  width: double.infinity,
                  // height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Source: Wikimedia Commons ($imagePath)',
                  style: TextStyle(color: color, fontSize: bodyFontSize * 0.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
