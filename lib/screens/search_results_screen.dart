import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:wikimedia_core/wikimedia_core.dart';
import '../providers/app_state.dart';
import 'article_screen.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  final List<Map<String, dynamic>> _results = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String _errorMessage = '';
  int? _nextOffset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchResults();
    });
  }

  Future<void> _fetchResults({bool isLoadMore = false}) async {
    if (_isLoadingMore || _nextOffset == null) return;
    if (_isLoading && _results.isNotEmpty && !isLoadMore) return;

    setState(() {
      if (isLoadMore) {
        _isLoadingMore = true;
      } else {
        _isLoading = true;
      }
      _hasError = false;
    });

    try {
      final langCode = context.locale.languageCode;
      final currentProject = ref.read(appStateProvider);

      final response = await WikiApiService.searchArticles(
        widget.query,
        langCode,
        currentProject.name.toLowerCase(),
        offset: _nextOffset!,
        limit: 20,
      );

      if (!mounted) return;

      setState(() {
        _results.addAll(response['results'] as List<Map<String, dynamic>>);
        _nextOffset = response['nextOffset'] as int?;
        if (isLoadMore) {
          _isLoadingMore = false;
        } else {
          _isLoading = false;
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        if (isLoadMore) {
          _isLoadingMore = false;
        } else {
          _isLoading = false;
        }
      });
    }
  }

  String _cleanSnippet(String snippet) {
    // Decode entities like &#039;
    final document = html_parser.parse(snippet);
    final String decodedText = document.body?.text ?? '';
    return decodedText.trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              '${'search_results'.tr()}: ${widget.query}',
              style: GoogleFonts.montserratAlternates(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                fontSize: 18,
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_hasError && _results.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _fetchResults(),
                        icon: const Icon(Icons.refresh),
                        label: Text('search_retry'.tr()),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (_results.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index == _results.length) {
                    if (_isLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (_nextOffset != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: OutlinedButton(
                            onPressed: () => _fetchResults(isLoadMore: true),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Text('load_more').tr(),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink(); // No more results
                    }
                  }

                  final result = _results[index];
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
                            color: theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
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
                }, childCount: _results.length + 1),
              ),
            ),
        ],
      ),
    );
  }
}
