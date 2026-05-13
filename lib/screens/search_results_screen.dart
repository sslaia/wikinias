import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' as html_parser;

import '../services/wiki_api_service.dart';
import '../providers/app_state.dart';
import 'article_screen.dart';

class SearchResultsScreen extends ConsumerWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  String _cleanSnippet(String snippet) {
    // Decode entities like &#039;
    final document = html_parser.parse(snippet);
    final String decodedText = document.body?.text ?? '';
    return decodedText.trim();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final langCode = context.locale.languageCode;
    final currentProject = ref.watch(appStateProvider);

    // Fallback fonts for Javanese and other scripts
    final List<String> fontFallbacks = [
      GoogleFonts.notoSansJavanese().fontFamily!,
      'Roboto',
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 2,
            backgroundColor: theme.colorScheme.surface,
            iconTheme: IconThemeData(color: theme.colorScheme.primary),
            title: Text(
              '${'search_results'.tr()}: $query',
              style: GoogleFonts.montserratAlternates(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                fontSize: 18,
              ),
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: WikiApiService.searchArticles(
              query,
              langCode,
              currentProject.name.toLowerCase(),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'search_failed'.tr(),
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () =>
                                (context as Element).markNeedsBuild(),
                            icon: const Icon(Icons.refresh),
                            label: Text('search_retry'.tr()),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final results = snapshot.data ?? [];

              if (results.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'search_no_results'.tr(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final result = results[index];
                    final title = result['title'] as String;
                    final snippet = result['snippet'] as String;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ArticleScreen(title: title),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style:
                                          GoogleFonts.notoSerif(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: theme.colorScheme.onSurface,
                                          ).copyWith(
                                            fontFamilyFallback: fontFallbacks,
                                          ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              if (snippet.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  _cleanSnippet(snippet),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.notoSerif(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ).copyWith(fontFamilyFallback: fontFallbacks),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }, childCount: results.length),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
