import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/project_type.dart';
import '../utils/responsive_utils.dart';
import '../widgets/shortcuts_side_bar.dart';
import '../widgets/wiki_portals_widget.dart';
import '../widgets/contribute_widget.dart';
import '../widgets/wiki_footer.dart';
import '../models/home_page_section.dart';
import '../widgets/search_field_widget.dart';
import '../widgets/custom_bottom_app_bar.dart';
import '../widgets/adaptive_section_card.dart';
import '../widgets/adaptive_nav_actions.dart';
import '../providers/app_state.dart';
import '../providers/wiki_api_provider.dart';
import '../widgets/drawer_menu.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(appStateProvider);
    final wikiContent = ref.watch(wikiApiProvider(null));
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveUtils.getDeviceType(context);
        final isCompact = deviceType == DeviceType.compact;
        final isTablet = deviceType != DeviceType.compact;
        final isLandscape = ResponsiveUtils.isLandscape(context);
        final isCompactLandscape = isCompact && isLandscape;
        final isCompactPortrait = isCompact && !isLandscape;
        final isTabletLandscape = isTablet && isLandscape;
        final bool showShortcutsSideBar = isTabletLandscape || deviceType == DeviceType.expanded;

        return Scaffold(
          key: _scaffoldKey,
          drawer: const DrawerMenu(),
          bottomNavigationBar: isCompactPortrait
              ? CustomBottomAppBar(
                  scaffoldKey: _scaffoldKey,
                  currentProject: currentProject,
                  isHomeScreen: true,
                )
              : null,
          body: Row(
            children: [
              if (showShortcutsSideBar)
                const ShortcutsSidebar(),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: wikiContent.when(
                        data: (content) {
                          String? featuredImageUrl;
                          if (content is List<HomePageSection>) {
                            for (var section in content) {
                              if (section.titleKey == 'featuredImage') {
                                featuredImageUrl = section.imageUrl;
                                break;
                              }
                            }
                            if (featuredImageUrl == null ||
                                featuredImageUrl.isEmpty) {
                              for (var section in content) {
                                if (section.imageUrl != null &&
                                    section.imageUrl!.isNotEmpty) {
                                  featuredImageUrl = section.imageUrl;
                                  break;
                                }
                              }
                            }
                          }

                          return _buildHero(
                            context,
                            currentProject,
                            featuredImageUrl,
                          );
                        },
                        loading: () => _buildLoadingHero(currentProject),
                        error: (err, stack) => _buildErrorHero(currentProject),
                      ),
                    ),
                    wikiContent.when(
                      data: (content) {
                        if (content is List<HomePageSection>) {
                          return SliverPadding(
                            padding: const EdgeInsets.all(16.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return AdaptiveSectionCard(
                                  section: content[index],
                                  project: currentProject,
                                );
                              }, childCount: content.length),
                            ),
                          );
                        }
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      },
                      loading: () =>
                          const SliverToBoxAdapter(child: SizedBox.shrink()),
                      error: (err, stack) =>
                          const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ),
                    SliverToBoxAdapter(
                      child: WikiPortalsWidget(
                        project: currentProject,
                        languageCode: context.locale.languageCode,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: ContributeWidget(project: currentProject),
                    ),
                    const SliverToBoxAdapter(child: WikiFooter()),
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ),
              ),
              if (isCompactLandscape || isTablet)
                Container(
                  width: 56,
                  color: theme.colorScheme.primary,
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
                                isHomeScreen: true,
                                showHome: false,
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

  Widget _buildHero(
    BuildContext context,
    ProjectType currentProject,
    String? featuredImageUrl,
  ) {
    return Stack(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: featuredImageUrl != null && featuredImageUrl.isNotEmpty
              ? Image.network(
                  featuredImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    currentProject.homeHeroImagePath,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  currentProject.homeHeroImagePath,
                  fit: BoxFit.cover,
                ),
        ),
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'welcome_to'.tr(),
                    style: GoogleFonts.offside(
                      textStyle: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            shadows: const [
                              Shadow(blurRadius: 10, color: Colors.black),
                            ],
                          ),
                    ),
                  ),
                  Text(
                    currentProject.name.toLowerCase().tr(),
                    style: GoogleFonts.cinzelDecorative(
                      textStyle: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(blurRadius: 10, color: Colors.black),
                            ],
                          ),
                    ),
                  ),
                  Text(
                    context.locale.languageCode.toLowerCase().tr(),
                    style: GoogleFonts.cinzelDecorative(
                      textStyle: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            shadows: const [
                              Shadow(blurRadius: 10, color: Colors.black),
                            ],
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'motto'.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.offside(
                      textStyle: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            shadows: const [
                              Shadow(blurRadius: 10, color: Colors.black),
                            ],
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SearchFieldWidget(context: context, theme: Theme.of(context)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingHero(ProjectType currentProject) {
    return Container(
      height: 200,
      color: currentProject.primaryColor.withValues(alpha: 0.1),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorHero(ProjectType currentProject) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(currentProject.homeHeroImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        alignment: Alignment.center,
        child: const Icon(Icons.error_outline, color: Colors.white),
      ),
    );
  }
}
