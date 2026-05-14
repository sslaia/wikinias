import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_type.dart';
import '../providers/app_state.dart';
import '../providers/onboarding_provider.dart';
import '../utils/responsive_utils.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length + 1, // +1 for the final language selection page
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  if (index < _pages.length) {
                    return _buildPage(_pages[index], size, theme);
                  } else {
                    return _buildFinalLanguageSelectionPage(size, theme);
                  }
                },
              ),
            ),
            _buildBottomControls(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(ThemeData theme) {
    final isCompact = ResponsiveUtils.isCompact(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16.0 : 24.0,
        vertical: isCompact ? 16.0 : 24.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Row(
            children: [
              // Left Button (Back or Skip)
              SizedBox(
                width: isCompact ? 70 : 100,
                child: _buildLeftButton(theme),
              ),

              // Page Indicators
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length + 1,
                    (index) => _buildIndicator(index, theme),
                  ),
                ),
              ),

              // Right Button (Next or Get Started)
              SizedBox(
                width: isCompact ? 100 : 120,
                child: _buildRightButton(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftButton(ThemeData theme) {
    if (_currentPage > 0) {
      return IconButton(
        onPressed: () {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        icon: Icon(Icons.arrow_back_ios_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
      );
    } else {
      return TextButton(
        onPressed: () => _pageController.animateToPage(
          _pages.length,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
        child: Text('skip'.tr(),
            textAlign: TextAlign.left,
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
      );
    }
  }

  Widget _buildRightButton(ThemeData theme) {
    if (_currentPage == _pages.length) {
      return ElevatedButton(
        onPressed: () => _complete(ref, context),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text('get_started'.tr(), style: const TextStyle(fontSize: 12)),
      );
    } else {
      return IconButton(
        onPressed: () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        icon: Icon(Icons.arrow_forward_ios_rounded,
            color: _currentPage < _pages.length
                ? _pages[_currentPage].color
                : theme.colorScheme.primary),
      );
    }
  }

  Widget _buildPage(OnboardingData page, Size size, ThemeData theme) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final isCompact = ResponsiveUtils.isCompact(context);

    if (isLandscape) {
      return Row(
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
                    SizedBox(height: isTablet ? 40 : 20),
                    _buildLanguageSelector(context, theme),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Portrait screens
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            SizedBox(height: isCompact ? 10 : size.height * 0.05),
            Container(
              width: isTablet ? 500 : size.width * 0.85,
              height: isCompact ? size.height * 0.35 : size.height * 0.4,
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
                  const SizedBox(height: 30),
                  Text(
                    page.titleKey.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserratAlternates(
                      fontSize: isCompact ? 22 : (isTablet ? 32 : 26),
                      fontWeight: FontWeight.w800,
                      color: page.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    page.descKey.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerif(
                      fontSize: isCompact ? 14 : (isTablet ? 18 : 16),
                      height: 1.4,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLanguageSelector(context, theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalLanguageSelectionPage(Size size, ThemeData theme) {
    final isTablet = ResponsiveUtils.isTablet(context);
    final isCompact = ResponsiveUtils.isCompact(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 80.0 : 40.0,
          vertical: 40.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.translate, size: isCompact ? 60 : 80, color: theme.colorScheme.primary),
            SizedBox(height: isCompact ? 24 : 40),
            Text(
              'select_project_language'.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.montserratAlternates(
                fontSize: isCompact ? 22 : (isTablet ? 32 : 26),
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'select_language_description'.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerif(
                fontSize: isCompact ? 14 : (isTablet ? 18 : 16),
                height: 1.4,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: isCompact ? 24 : 40),
            _buildLanguageSelector(context, theme, isFinalPage: true),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index, ThemeData theme) {
    final isCompact = ResponsiveUtils.isCompact(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: isCompact ? 6 : 8),
      height: isCompact ? 6 : 8,
      width: _currentPage == index ? (isCompact ? 18 : 24) : (isCompact ? 6 : 8),
      decoration: BoxDecoration(
        color: _currentPage == index
            ? (_currentPage < _pages.length ? _pages[_currentPage].color : theme.colorScheme.primary)
            : theme.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Future<void> _complete(WidgetRef ref, BuildContext context) async {
    // Ensure project is always set to Wikipedia on completion
    final currentLang = ref.read(languageProvider);
    ref.read(appStateProvider.notifier).setProject(ProjectType.wikipedia, currentLang);

    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  Widget _buildLanguageSelector(BuildContext context, ThemeData theme, {bool isFinalPage = false}) {
    final isCompact = ResponsiveUtils.isCompact(context);
    return PopupMenuButton<Locale>(
      onSelected: (Locale locale) async {
        await context.setLocale(locale);
        ref.read(languageProvider.notifier).setLanguage(locale.languageCode);
      },
      icon: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 12 : 16,
          vertical: isCompact ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: isFinalPage ? theme.colorScheme.primary.withValues(alpha: 0.1) : null,
          border: Border.all(color: isFinalPage ? theme.colorScheme.primary : theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.translate, size: isCompact ? 18 : 20, color: isFinalPage ? theme.colorScheme.primary : null),
            SizedBox(width: isCompact ? 8 : 12),
            Flexible(
              child: Text(
                isFinalPage
                  ? _getLanguageName(context.locale.languageCode)
                  : 'select_language'.tr(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isFinalPage ? theme.colorScheme.primary : null,
                  fontSize: isCompact ? 12 : 14,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down, size: isCompact ? 18 : 20, color: isFinalPage ? theme.colorScheme.primary : null),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: Locale('id'), child: Text('Bahasa Indonesia')),
        const PopupMenuItem(value: Locale('en'), child: Text('English')),
        const PopupMenuItem(value: Locale('nia'), child: Text('Li Niha')),
      ],
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'id': return 'Bahasa Indonesia';
      case 'en': return 'English';
      case 'nia': return 'Li Niha';
      default: return code.toUpperCase();
    }
  }
}

class OnboardingData {
  final String titleKey;
  final String descKey;
  final String imagePath;
  final Color color;

  OnboardingData({
    required this.titleKey,
    required this.descKey,
    required this.imagePath,
    required this.color,
  });
}
