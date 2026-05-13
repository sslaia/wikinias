import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as html_parser;

import '../models/project_type.dart';
import '../services/wiki_api_service.dart';
import '../utils/wiki_utils.dart';
import '../widgets/wiki_footer.dart';
import '../utils/responsive_utils.dart';
import '../widgets/adaptive_nav_actions.dart';
import '../widgets/shortcuts_side_bar.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/custom_bottom_app_bar.dart';
import '../providers/bookmarks_provider.dart';
import 'image_screen.dart';

class NiasCourseScreen extends ConsumerStatefulWidget {
  const NiasCourseScreen({super.key});

  @override
  ConsumerState<NiasCourseScreen> createState() => _NiasCourseScreenState();
}

class _NiasCourseScreenState extends ConsumerState<NiasCourseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _courseTitle;

  @override
  void initState() {
    super.initState();
    _courseTitle = 'Wikikamus:Sulu';
  }

  @override
  Widget build(BuildContext context) {
    // Explicitly target Nias Wiktionary
    final courseContent = ref.watch(courseApiProvider(_courseTitle));
    final theme = Theme.of(context);

    // Mix of project colors
    final mixedColor = Color.lerp(
      ProjectType.wikipedia.primaryColor,
      Color.lerp(
        ProjectType.wiktionary.primaryColor,
        ProjectType.wikibooks.primaryColor,
        0.5,
      ),
      0.5,
    )!;

    final String pageUrl = 'https://nia.wiktionary.org/wiki/${_courseTitle.replaceAll(' ', '_')}';

    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveUtils.getDeviceType(context);
        final isLandscape = ResponsiveUtils.isLandscape(context);
        final isCompact = deviceType == DeviceType.compact;
        final isTablet = deviceType != DeviceType.compact;
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
            currentProject: ProjectType.wiktionary,
            pageTitle: _courseTitle,
          )
              : null,
          body: Row(
            children: [
              if (showShortcutsSideBar)
                const ShortcutsSidebar(),
              Expanded(
                child: Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          expandedHeight: 200.0,
                          floating: true,
                          pinned: false,
                          snap: true,
                          backgroundColor: mixedColor,
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Text(
                              "Hadia Ö'ila?",
                              style: GoogleFonts.cinzelDecorative(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            background: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    ProjectType.wikipedia.primaryColor,
                                    ProjectType.wiktionary.primaryColor,
                                    ProjectType.wikibooks.primaryColor,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.auto_stories_rounded,
                                      size: 60,
                                      color: Colors.white.withValues(alpha: 0.3),
                                    ),
                                    const SizedBox(height: 40), // Spacer for title
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        "Kese-keseda ba mbaŵa andre",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.merriweather(
                                          fontSize: 14,
                                          color: Colors.white.withValues(alpha: 0.9),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        courseContent.when(
                          data: (data) {
                            String htmlContent;

                            if (data is Map<String, dynamic>) {
                              htmlContent = data['html'] ?? '';
                            } else if (data is String) {
                              htmlContent = data;
                            } else {
                              htmlContent = '';
                            }

                            if (htmlContent.isEmpty ||
                                htmlContent.contains('Error: Could not parse')) {
                              return const SliverFillRemaining(
                                child: Center(child: Text('Error: Could not load content')),
                              );
                            }

                            // Strip all inline styles to use app fonts and styles
                            final cleanHtml = htmlContent.replaceAll(
                              RegExp(r'style="[^"]*"'),
                              '',
                            );

                            // Parse and extract specific Sulu lesson components
                            final doc = html_parser.parse(cleanHtml);

                            final titleElement = doc.querySelector('.lesson-title');
                            final contentElement = doc.querySelector('.lesson-content');

                            final lessonTitle = titleElement?.text.trim() ?? '';

                            // Remove title from the document to prevent duplicate rendering and spacing issues
                            titleElement?.remove();

                            // Surgical content extraction: prefer .lesson-content, then .mw-parser-output, then body.
                            String cleanBody;
                            if (contentElement != null) {
                              cleanBody = contentElement.innerHtml.trim();
                            } else {
                              final mainContent = doc.querySelector('.mw-parser-output') ?? doc.body;
                              cleanBody = mainContent?.innerHtml.trim() ?? cleanHtml.trim();
                            }

                            var currentProject = ProjectType.wiktionary;

                            return SliverPadding(
                              padding: const EdgeInsets.all(16.0),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  if (lessonTitle.isNotEmpty) ...[
                                    Text(
                                      lessonTitle,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserratAlternates(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: mixedColor,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  HtmlWidget(
                                    cleanBody,
                                    textStyle: GoogleFonts.notoSerif(
                                      height: 1.8,
                                      fontSize: 16,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                                    ),
                                    onTapUrl: (url) =>
                                        WikiUtils.handleTapUrl(context, url, htmlContent, currentProject),
                                    customStylesBuilder: (element) {
                                      if (element.localName == 'blockquote') {
                                        return {
                                          'border-left':
                                          '4px solid ${mixedColor.toHtmlRgba()}',
                                          'background-color': mixedColor
                                              .withValues(alpha: 0.05)
                                              .toHtmlRgba(),
                                          'padding': '16px',
                                          'margin': '16px 0',
                                          'font-style': 'italic',
                                          'border-radius': '0 12px 12px 0',
                                        };
                                      }
                                      return WikiUtils.customStyles(context, element);
                                    },
                                    customWidgetBuilder: (element) {
                                      // Handle images: animate them and make them clickable
                                      if (element.localName == 'img' ||
                                          element.localName == 'figure' ||
                                          element.classes.contains('thumb')) {
                                        final img = element.localName == 'img'
                                            ? element
                                            : element.querySelector('img');

                                        if (img != null) {
                                          final src = img.attributes['src'] ?? '';
                                          if (src.isNotEmpty && !WikiUtils.isIcon(src)) {
                                            final fullUrl = src.startsWith('http')
                                                ? src
                                                : 'https:$src';
                                            return _buildAnimatedHeroImage(
                                              fullUrl,
                                              mixedColor,
                                            );
                                          }
                                        }
                                      }

                                      return WikiUtils.customWidgetBuilder(context, element);
                                    },
                                  ),
                                  const SizedBox(height: 32),
                                  const WikiFooter(),
                                  const SizedBox(height: 120),
                                ]),
                              ),
                            );
                          },
                          loading: () => const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (err, stack) =>
                              SliverFillRemaining(child: Center(child: Text('Error: $err'))),
                        ),
                      ],
                    ),
                    _buildFloatingActionBar(
                      theme,
                      pageUrl,
                      _courseTitle,
                    ),
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
                        icon: const Icon(Icons.menu),
                        color: theme.colorScheme.onPrimary,
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
                                currentProject: ProjectType.wiktionary,
                                isHomeScreen: false,
                                showHome: true,
                                pageTitle: _courseTitle,
                                color: theme.colorScheme.onPrimary,
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

  Widget _buildFloatingActionBar(
      ThemeData theme,
      String pageUrl,
      String currentTitle,
      ) {
    final bookmarks = ref.watch(bookmarksProvider);
    const langCode = 'nia';
    final projectName = ProjectType.wiktionary.name;

    final isBookmarked = bookmarks.any(
          (b) =>
      b.title == currentTitle &&
          b.langCode == langCode &&
          b.projectName == projectName,
    );

    return Positioned(
      bottom: 24 + MediaQuery.paddingOf(context).bottom,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                theme,
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                isBookmarked ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                onPressed: () {
                  ref
                      .read(bookmarksProvider.notifier)
                      .toggleBookmark(currentTitle, langCode, projectName);

                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isBookmarked ? 'bookmarks_removed'.tr() : 'bookmarks_added'.tr(),
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              _buildDivider(theme),
              _buildActionButton(
                theme,
                Icons.share_outlined,
                theme.colorScheme.onSurface,
                onPressed: () {
                  SharePlus.instance.share(
                    ShareParams(uri: Uri.parse(pageUrl)),
                  );
                },
              ),
              _buildDivider(theme),
              _buildActionButton(
                theme,
                Icons.visibility_outlined,
                theme.colorScheme.onSurface,
                onPressed: () async {
                  final uri = Uri.parse(pageUrl);
                  try {
                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('page_cant_open').tr()),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      ThemeData theme,
      IconData icon,
      Color color, {
        VoidCallback? onPressed,
      }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(icon, color: color, size: 18),
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      height: 20,
      width: 1,
      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildAnimatedHeroImage(String url, Color themeColor) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageScreen(imagePath: url),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: themeColor.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}

extension ColorToHtml on Color {
  String toHtmlRgba() {
    return 'rgba($r, $g, $b, $a)';
  }
}

// Special provider for course to force Nias Wiktionary
final courseApiProvider = FutureProvider.autoDispose.family<dynamic, String>((
    ref,
    pageTitle,
    ) async {
  return WikiApiService.fetchPageHtml(
    ProjectType.wiktionary,
    'nia',
    pageTitle,
    true,
  );
});
