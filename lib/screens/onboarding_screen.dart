import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/onboarding_provider.dart';
import 'home_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      titleKey: 'onboarding_title_1',
      descKey: 'onboarding_desc_1',
      imagePath: 'assets/images/onboarding1.webp',
      color: const Color(0xFF121298),
    ),
    OnboardingData(
      titleKey: 'onboarding_title_2',
      descKey: 'onboarding_desc_2',
      imagePath: 'assets/images/onboarding2.webp',
      color: const Color(0xFF9B00A1),
    ),
    OnboardingData(
      titleKey: 'onboarding_title_3',
      descKey: 'onboarding_desc_3',
      imagePath: 'assets/images/onboarding3.webp',
      color: const Color(0xFF121298),
    ),
    OnboardingData(
      titleKey: 'onboarding_title_4',
      descKey: 'onboarding_desc_4',
      imagePath: 'assets/images/onboarding4.webp',
      color: const Color(0xFFFF5722),
    ),
    OnboardingData(
      titleKey: 'onboarding_title_5',
      descKey: 'onboarding_desc_5',
      imagePath: 'assets/images/onboarding5.webp',
      color: const Color(0xFF9B00A1),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return _buildPage(_pages[index], size, theme);
            },
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        IconButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: Icon(Icons.arrow_back_ios_rounded,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                        )
                      else
                        TextButton(
                          onPressed: () => _complete(ref, context),
                          child: Text('skip'.tr(),
                              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                        ),

                      Row(
                        children: List.generate(
                          _pages.length,
                              (index) => _buildIndicator(index, theme),
                        ),
                      ),

                      _currentPage == _pages.length - 1
                          ? ElevatedButton(
                        onPressed: () => _complete(ref, context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pages[_currentPage].color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('get_started'.tr()),
                      )
                          : IconButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded, color: _pages[_currentPage].color),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData page, Size size, ThemeData theme) {
    final isLandscape = size.width > size.height;
    final isTablet = size.width > 600;

    if (isLandscape) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 80.0), // Space for bottom controls
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 40.0 : 20.0),
                child: Image.asset(
                  page.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 60.0 : 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        page.titleKey.tr(),
                        style: GoogleFonts.montserratAlternates(
                          fontSize: isTablet ? 32 : 24,
                          fontWeight: FontWeight.w800,
                          color: page.color,
                        ),
                      ),
                      SizedBox(height: isTablet ? 24 : 12),
                      Text(
                        page.descKey.tr(),
                        style: GoogleFonts.notoSerif(
                          fontSize: isTablet ? 18 : 14,
                          height: 1.5,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Portrait screens
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.1),
          Container(
            width: isTablet ? 500 : size.width,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(page.imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 80.0 : 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                Text(
                  page.titleKey.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserratAlternates(
                    fontSize: isTablet ? 32 : 26,
                    fontWeight: FontWeight.w800,
                    color: page.color,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  page.descKey.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerif(
                    fontSize: isTablet ? 18 : 16,
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 160 : 120),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index, ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? _pages[_currentPage].color : theme.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Future<void> _complete(WidgetRef ref, BuildContext context) async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }
}

class OnboardingData {
  final String titleKey;
  final String descKey;
  final String imagePath; // Changed from IconData
  final Color color;

  OnboardingData({
    required this.titleKey,
    required this.descKey,
    required this.imagePath,
    required this.color,
  });
}