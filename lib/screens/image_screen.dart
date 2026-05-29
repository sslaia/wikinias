import 'package:flutter/material.dart';
import '../services/commons_service.dart';

class ImageScreen extends StatefulWidget {
  final String imagePath;
  final String? fileName;
  final String? title;

  const ImageScreen({
    super.key,
    required this.imagePath,
    this.fileName,
    this.title,
  });

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  Map<String, dynamic>? _metadata;
  bool _isLoadingMetadata = false;

  @override
  void initState() {
    super.initState();
    if (widget.fileName != null) {
      _loadMetadata();
    }
  }

  Future<void> _loadMetadata() async {
    setState(() => _isLoadingMetadata = true);
    final info = await CommonsService.fetchImageInfo(widget.fileName!);
    if (mounted) {
      setState(() {
        _metadata = info;
        _isLoadingMetadata = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? license = _metadata?['extmetadata']?['LicenseShortName']?['value'];
    final String? artist = _metadata?['extmetadata']?['Artist']?['value'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: widget.title != null 
          ? Text(widget.title!, style: const TextStyle(color: Colors.white, fontSize: 16))
          : null,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 10.0,
              child: Hero(
                tag: widget.imagePath,
                child: widget.imagePath.startsWith('http')
                    ? Image.network(
                        widget.imagePath,
                        fit: BoxFit.contain,
                        // headers: WikiUtils.uaHeaders, // Removed headers
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white,
                            ),
                          );
                        },
                      )
                    : Image.asset(widget.imagePath, fit: BoxFit.contain),
              ),
            ),
          ),
          
          // Metadata Panel (Bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoadingMetadata)
                    const Center(child: LinearProgressIndicator(color: Colors.white))
                  else if (_metadata != null) ...[
                    if (license != null)
                      _buildInfoRow(Icons.copyright, license),
                    if (artist != null)
                      _buildInfoRow(Icons.person, _stripHtml(artist)),
                    _buildInfoRow(Icons.link, widget.imagePath, isUrl: true),
                  ] else ...[
                    Text(
                      widget.imagePath,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sourced from Wikimedia Commons. Use under respective Creative Commons or Public Domain licenses.',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isUrl = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isUrl ? Colors.blue : Colors.white,
                fontSize: 12,
                decoration: isUrl ? TextDecoration.underline : null,
              ),
              maxLines: isUrl ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _stripHtml(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }
}
