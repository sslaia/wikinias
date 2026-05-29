import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wikimedia_core/wikimedia_core.dart';
import '../providers/app_state.dart';
import '../providers/gallery_provider.dart';
import '../services/commons_service.dart';
import '../utils/responsive_utils.dart';
import '../widgets/adaptive_nav_actions.dart';
import '../widgets/custom_bottom_app_bar.dart';
import '../widgets/drawer_menu.dart';
import 'image_screen.dart';

class GalleryCarouselScreen extends ConsumerStatefulWidget {
  const GalleryCarouselScreen({super.key});

  static const Color niasRed = Color(0xFFD32F2F);
  static const Color niasYellow = Color(0xFFFBC02D);

  @override
  ConsumerState<GalleryCarouselScreen> createState() =>
      _GalleryCarouselScreenState();
}

class _GalleryCarouselScreenState extends ConsumerState<GalleryCarouselScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late CarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final galleryDataAsync = ref.watch(galleryDataProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final currentProject = ref.watch(appStateProvider);

    // Reset scroll position when category changes
    ref.listen(selectedCategoryProvider, (previous, next) {
      if (previous != next) {
        if (_carouselController.hasClients) {
          _carouselController.jumpTo(0);
        }
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveUtils.getDeviceType(context);
        final isLandscape = ResponsiveUtils.isLandscape(context);
        final isCompactPortrait =
            deviceType == DeviceType.compact && !isLandscape;
        final isCompactLandscape =
            deviceType == DeviceType.compact && isLandscape;
        final isTablet = deviceType != DeviceType.compact;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.black,
          drawer: const DrawerMenu(),
          bottomNavigationBar: isCompactPortrait
              ? CustomBottomAppBar(
                  scaffoldKey: _scaffoldKey,
                  currentProject: currentProject,
                  isHomeScreen: false,
                )
              : null,
          body: Row(
            children: [
              Expanded(
                child: galleryDataAsync.when(
                  data: (data) {
                    final items = selectedCategory != null
                        ? data[selectedCategory]
                        : null;
                    return Stack(
                      children: [
                        // Main Vertical Carousel
                        if (items != null && items.isNotEmpty)
                          CarouselView(
                            controller: _carouselController,
                            scrollDirection: Axis.vertical,
                            itemExtent: constraints.maxHeight,
                            shrinkExtent: constraints.maxHeight * 0.2,
                            padding: EdgeInsets.zero,
                            onTap: (index) {
                              final item = items[index];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageScreen(
                                    imagePath: CommonsService.getOriginalUrl(
                                      item.fileName,
                                    ),
                                    fileName: item.fileName,
                                    title: item.title,
                                  ),
                                ),
                              );
                            },
                            children: items.map((item) {
                              final thumbnailUrl =
                                  CommonsService.getThumbnailUrl(
                                    item.fileName,
                                    width: 900,
                                  );

                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    thumbnailUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  GalleryCarouselScreen.niasRed,
                                            ),
                                          );
                                        },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                              child: Icon(
                                                Icons.error,
                                                color: GalleryCarouselScreen
                                                    .niasRed,
                                              ),
                                            ),
                                  ),
                                  // Overlay Gradient
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.4),
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Caption
                                  Positioned(
                                    bottom: isCompactPortrait ? 40 : 100,
                                    left: 20,
                                    right: 20,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: GoogleFonts.cinzelDecorative(
                                            fontSize: isCompactPortrait
                                                ? 20
                                                : 28,
                                            fontWeight: FontWeight.bold,
                                            color: GalleryCarouselScreen
                                                .niasYellow,
                                            shadows: const [
                                              Shadow(
                                                blurRadius: 4,
                                                color: Colors.black,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (item.description != null) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            item.description!,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isCompactPortrait
                                                  ? 12
                                                  : 16,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          )
                        else
                          const Center(
                            child: Text(
                              'No images in this category.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                        // Category Selector (Top)
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          left: 0,
                          right: 0,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: data.keys.map((cat) {
                                final isSelected = selectedCategory == cat;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: ChoiceChip(
                                    label: Text(
                                      'gallery_$cat'.tr(),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    selected: isSelected,
                                    selectedColor:
                                        GalleryCarouselScreen.niasYellow,
                                    backgroundColor: Colors.black.withValues(alpha: 0.6),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: isSelected
                                            ? GalleryCarouselScreen.niasYellow
                                            : Colors.white24,
                                      ),
                                    ),
                                    onSelected: (selected) {
                                      if (selected) {
                                        ref
                                            .read(
                                              selectedCategoryProvider.notifier,
                                            )
                                            .setCategory(cat);
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        // Menu Button (Top Left if no AppBar)
                        if (isCompactPortrait)
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 10,
                            left: 10,
                            child:
                                const SizedBox.shrink(), // CustomBottomAppBar handles it
                          ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: GalleryCarouselScreen.niasRed,
                    ),
                  ),
                  error: (err, stack) => Center(
                    child: Text(
                      'Error: $err',
                      style: const TextStyle(
                        color: GalleryCarouselScreen.niasRed,
                      ),
                    ),
                  ),
                ),
              ),
              if (isCompactLandscape || isTablet)
                Container(
                  width: 56,
                  color: currentProject.primaryColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: AdaptiveNavActions.buildActions(
                                context,
                                ref,
                                currentProject: currentProject,
                                isHomeScreen: false,
                                showHome: true,
                                color: Colors.white,
                              ).map((w) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: w,
                              )).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
