import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/project_type.dart';
import '../providers/app_state.dart';
import '../providers/bookmarks_provider.dart';
import 'article_screen.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bookmarks = ref.watch(bookmarksProvider);
    final currentProject = ref.watch(appStateProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 20),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    alignment: Alignment.centerLeft,
                    icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 16),
                  _buildHeader(theme, bookmarks.length),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            if (bookmarks.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(theme),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final bookmark = bookmarks[index];
                    return _buildBookmarkItem(context, ref, theme, bookmark, currentProject);
                  },
                  childCount: bookmarks.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'bookmarks'.tr(),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            fontSize: 32,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border_rounded,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'bookmarks_empty'.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'bookmarks_empty_hint'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkItem(
      BuildContext context,
      WidgetRef ref,
      ThemeData theme,
      BookmarkedArticle bookmark,
      ProjectType currentProject,
      ) {
    final isExternal = bookmark.projectName != currentProject.name;
    final projectColor = _getProjectColor(bookmark.projectName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _handleBookmarkTap(context, bookmark, currentProject),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildProjectBadge(bookmark.projectName, projectColor),
                      const SizedBox(width: 8),
                      _buildLanguageBadge(theme, bookmark.langCode),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 20),
                        color: theme.colorScheme.error.withValues(alpha: 0.7),
                        onPressed: () {
                          ref.read(bookmarksProvider.notifier).toggleBookmark(
                            bookmark.title,
                            bookmark.langCode,
                            bookmark.projectName,
                          );
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bookmark.title,
                    style: GoogleFonts.notoSerif(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        isExternal ? 'open_in_browser'.tr() : 'read_article'.tr(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: projectColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isExternal ? Icons.open_in_new_rounded : Icons.arrow_forward_rounded,
                        size: 14,
                        color: projectColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildBookmarksList(
  //   BuildContext context,
  //   WidgetRef ref,
  //   ThemeData theme,
  //   List<BookmarkedArticle> bookmarks,
  //   ProjectType currentProject,
  // ) {
  //   return ListView.builder(
  //     padding: const EdgeInsets.only(bottom: 32),
  //     itemCount: bookmarks.length + 1,
  //     itemBuilder: (context, index) {
  //       if (index == 0) {
  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SizedBox(height: MediaQuery.of(context).padding.top + 20),
  //             IconButton(
  //               padding: EdgeInsets.zero,
  //               constraints: const BoxConstraints(),
  //               alignment: Alignment.centerLeft,
  //               icon: const Icon(Icons.arrow_back),
  //               onPressed: () => Navigator.of(context).pop(),
  //             ),
  //             const SizedBox(height: 16),
  //             _buildHeader(theme, bookmarks.length),
  //             const SizedBox(height: 24),
  //           ],
  //         );
  //       }
  //
  //       final bookmark = bookmarks[index - 1];
  //       final isExternal = bookmark.projectName != currentProject.name;
  //
  //       // Get project color (indigo for wikipedia, deep orange for wiktionary, purple for wikibooks)
  //       final projectColor = _getProjectColor(bookmark.projectName);
  //
  //       return Padding(
  //         padding: const EdgeInsets.only(bottom: 16.0),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: theme.colorScheme.surface,
  //             borderRadius: BorderRadius.circular(20),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withValues(alpha: 0.04),
  //                 blurRadius: 12,
  //                 offset: const Offset(0, 4),
  //               ),
  //             ],
  //           ),
  //           child: Material(
  //             color: Colors.transparent,
  //             child: InkWell(
  //               borderRadius: BorderRadius.circular(20),
  //               onTap: () => _handleBookmarkTap(context, bookmark, currentProject),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(20.0),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         _buildProjectBadge(bookmark.projectName, projectColor),
  //                         const SizedBox(width: 8),
  //                         _buildLanguageBadge(theme, bookmark.langCode),
  //                         const Spacer(),
  //                         IconButton(
  //                           icon: const Icon(Icons.delete_outline_rounded, size: 20),
  //                           color: theme.colorScheme.error.withValues(alpha: 0.7),
  //                           onPressed: () {
  //                             ref.read(bookmarksProvider.notifier).toggleBookmark(
  //                               bookmark.title,
  //                               bookmark.langCode,
  //                               bookmark.projectName,
  //                             );
  //                           },
  //                           visualDensity: VisualDensity.compact,
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 12),
  //                     Text(
  //                       bookmark.title,
  //                       style: GoogleFonts.notoSerif(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold,
  //                         color: theme.colorScheme.onSurface,
  //                         height: 1.2,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16),
  //                     Row(
  //                       children: [
  //                         Text(
  //                           isExternal ? 'open_in_browser'.tr() : 'read_article'.tr(),
  //                           style: theme.textTheme.labelLarge?.copyWith(
  //                             color: projectColor,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 13,
  //                           ),
  //                         ),
  //                         const SizedBox(width: 4),
  //                         Icon(
  //                           isExternal ? Icons.open_in_new_rounded : Icons.arrow_forward_rounded,
  //                           size: 14,
  //                           color: projectColor,
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildProjectBadge(String projectName, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        projectName.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildLanguageBadge(ThemeData theme, String langCode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        langCode.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getProjectColor(String projectName) {
    switch (projectName.toLowerCase()) {
      case 'wikipedia':
        return const Color(0xFF121298);
      case 'wiktionary':
        return const Color(0xFFFF5722);
      case 'wikibooks':
        return const Color(0xFF9B00A1);
      default:
        return const Color(0xFF121298);
    }
  }

  void _handleBookmarkTap(BuildContext context, BookmarkedArticle bookmark, ProjectType currentProject) async {
    final currentLangCode = context.locale.languageCode;
    
    if (currentLangCode == bookmark.langCode && bookmark.projectName == currentProject.name) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArticleScreen(title: bookmark.title),
        ),
      );
    } else {
      final url = 'https://${bookmark.langCode}.${bookmark.projectName.toLowerCase()}.org/wiki/${bookmark.title.replaceAll(' ', '_')}';
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
    }
  }
}
