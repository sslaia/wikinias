import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/crosswords_provider.dart';
import '../widgets/crossword_grid.dart';
import '../widgets/scoreboard_widget.dart';
import '../models/crossword_model.dart';
import '../../../screens/article_screen.dart';

class CrosswordsScreen extends ConsumerStatefulWidget {
  const CrosswordsScreen({super.key});

  @override
  ConsumerState<CrosswordsScreen> createState() => _CrosswordsScreenState();
}

class _CrosswordsScreenState extends ConsumerState<CrosswordsScreen> {
  int _currentIndex = 0;
  final GlobalKey _globalKey = GlobalKey();
  bool _isSharing = false;

  Future<void> _captureAndShare(double score) async {
    setState(() {
      _isSharing = true;
    });

    try {
      // Small delay to ensure any UI states update if needed before capture
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary =
          _globalKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/crossword_score.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(pngBytes);

        final text =
            "${'crossword_share_1'.tr()} ${score.toStringAsFixed(1)}/10. ${'crossword_share_2'.tr()}";
        SharePlus.instance.share(
          ShareParams(files: [XFile(imagePath)], text: text),
        );
      }
    } catch (e) {
      debugPrint('Error capturing screenshot: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(crosswordsProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Theme.of(
          context,
        ).colorScheme.shadow.withValues(alpha: 0.2),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.grid_on_rounded),
            const SizedBox(width: 8),
            Text(
              'crosswords'.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          if (state.currentPuzzle != null &&
              state.currentPuzzle!.puzzleId !=
                  ref.read(crosswordsProvider.notifier).dailyPuzzleId &&
              _currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.today),
              tooltip: 'crossword_play'.tr(),
              onPressed: () {
                ref.read(crosswordsProvider.notifier).playDailyPuzzle();
              },
            ),
          if (state.currentPuzzle != null && _currentIndex == 0)
            IconButton(
              icon: Icon(
                state.favoritePuzzles.contains(state.currentPuzzle!.puzzleId)
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () {
                ref.read(crosswordsProvider.notifier).toggleFavorite();
              },
            ),
          if (state.currentPuzzle != null && _currentIndex == 0)
            IconButton(
              icon: _isSharing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.share),
              onPressed: _isSharing
                  ? null
                  : () {
                      final score =
                          ref
                              .read(crosswordsProvider.notifier)
                              .getScores()['weekly'] ??
                          0;
                      _captureAndShare(score.toDouble());
                    },
            ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.puzzles.isEmpty
          ? Center(child: Text('error_loading_contents'.tr()))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SegmentedButton<int>(
                    emptySelectionAllowed: true,
                    segments: [
                      ButtonSegment<int>(
                        value: 0,
                        label: Text(
                          'crossword_daily'.tr(),
                          style: TextStyle(fontSize: 12),
                        ),
                        icon: const Icon(Icons.grid_on),
                      ),
                      ButtonSegment<int>(
                        value: 2,
                        label: Text(
                          'crossword_favorites'.tr(),
                          style: TextStyle(fontSize: 12),
                        ),
                        icon: const Icon(Icons.favorite),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        label: Text(
                          'crossword_scoreboard'.tr(),
                          style: TextStyle(fontSize: 12),
                        ),
                        icon: const Icon(Icons.leaderboard),
                      ),
                    ],
                    selected: <int>{
                      if (_currentIndex == 1)
                        1
                      else if (_currentIndex == 2)
                        2
                      else if (_currentIndex == 0 &&
                          (state.currentPuzzle == null ||
                              state.currentPuzzle!.puzzleId ==
                                  ref
                                      .read(crosswordsProvider.notifier)
                                      .dailyPuzzleId))
                        0,
                    },
                    onSelectionChanged: (Set<int> newSelection) {
                      if (newSelection.isEmpty) return;
                      final int selectedIndex = newSelection.first;
                      if (selectedIndex == 0) {
                        ref.read(crosswordsProvider.notifier).playDailyPuzzle();
                      }
                      setState(() {
                        _currentIndex = selectedIndex;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _currentIndex == 0
                      ? _buildDailyCrossword(context, state, ref)
                      : _currentIndex == 1
                      ? const ScoreboardWidget()
                      : _buildFavoritesList(context, state, ref),
                ),
              ],
            ),
    );
  }

  Widget _buildFavoritesList(
    BuildContext context,
    CrosswordsState state,
    WidgetRef ref,
  ) {
    final favList = state.favoritePuzzles.toList()..sort();

    if (favList.isEmpty) {
      return Center(child: Text('crossword_no_favorite').tr());
    }

    return ListView.builder(
      itemCount: favList.length,
      itemBuilder: (context, index) {
        final puzzleId = favList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text('${'crosswords'.tr()} #$puzzleId'),
            trailing: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: Text('crossword_open').tr(),
              onPressed: () {
                ref.read(crosswordsProvider.notifier).playPuzzle(puzzleId);
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyCrossword(
    BuildContext context,
    CrosswordsState state,
    WidgetRef ref,
  ) {
    if (state.currentPuzzle == null) {
      return Center(child: Text('crossword_no').tr());
    }

    final canReveal = ref.read(crosswordsProvider.notifier).canRevealWords();

    bool isFullySolved = false;
    CrosswordWord? bonusWord;

    if (state.currentPuzzle != null) {
      int correctLetters = 0;
      final correctMap = <String, String>{};
      for (var word in state.currentPuzzle!.words) {
        for (int i = 0; i < word.word.length; i++) {
          int cx = word.direction == 'across' ? word.x + i : word.x;
          int cy = word.direction == 'down' ? word.y + i : word.y;
          correctMap['$cx,$cy'] = word.word[i].toUpperCase();
        }
      }

      int totalLetters = correctMap.length;
      correctMap.forEach((key, val) {
        if (state.userAnswers[key] == val) {
          correctLetters++;
        }
      });

      isFullySolved = (totalLetters > 0 && correctLetters == totalLetters);
      if (isFullySolved && state.currentPuzzle!.words.isNotEmpty) {
        bonusWord = state.currentPuzzle!.words.reduce(
          (a, b) => a.word.length > b.word.length ? a : b,
        );
      }
    }

    return SingleChildScrollView(
      child: RepaintBoundary(
        key: _globalKey,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'crossword_daily'.tr(),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CrosswordGrid(
                      puzzle: state.currentPuzzle!,
                      isFillable:
                          !canReveal &&
                          state.currentPuzzle!.puzzleId ==
                              ref
                                  .read(crosswordsProvider.notifier)
                                  .dailyPuzzleId,
                    ),
                    const SizedBox(height: 24),
                    if (canReveal)
                      if (isFullySolved && bonusWord != null)
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Bonus!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ArticleScreen(
                                        title: bonusWord!.pageTitle,
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${bonusWord.word.toUpperCase()} - ${bonusWord.clue}',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.open_in_new,
                                        size: 16,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        FilledButton.icon(
                          icon: const Icon(Icons.visibility),
                          label: Text('crossword_check_words'.tr()),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            ref.read(crosswordsProvider.notifier).revealWords();
                          },
                        )
                    else
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'crossword_notes'.tr(),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "crossword_notes_1".tr(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "crossword_notes_2".tr(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
