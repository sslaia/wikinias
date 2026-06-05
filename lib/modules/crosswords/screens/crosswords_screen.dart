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

class CrosswordsScreen extends ConsumerStatefulWidget {
  const CrosswordsScreen({Key? key}) : super(key: key);

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
            "No ufo'ösi dahö-dahö nifasulö ma'ökhö! Bua nisöndragu ba migu andre: ${score.toStringAsFixed(1)}/10. Ae ba aplikasi WikiNias ba wamo'ösi dahö-dahö! https://play.google.com/store/apps/details?id=com.sslaia.wikinias";

        await Share.shareXFiles([XFile(imagePath)], text: text);
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
        shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
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
              tooltip: 'Play Today\'s Puzzle',
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
                    segments: [
                      ButtonSegment<int>(
                        value: 0,
                        label: Text('crossword_daily'.tr()),
                        icon: const Icon(Icons.grid_on),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        label: Text('crossword_scoreboard'.tr()),
                        icon: const Icon(Icons.leaderboard),
                      ),
                      ButtonSegment<int>(
                        value: 2,
                        label: Text('crossword_favorites'.tr()),
                        icon: const Icon(Icons.favorite),
                      ),
                    ],
                    selected: <int>{_currentIndex},
                    onSelectionChanged: (Set<int> newSelection) {
                      setState(() {
                        _currentIndex = newSelection.first;
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
      return const Center(
        child: Text('No favorited crosswords yet.'),
      );
    }

    return ListView.builder(
      itemCount: favList.length,
      itemBuilder: (context, index) {
        final puzzleId = favList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text('Crossword #$puzzleId'),
            trailing: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play'),
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
      return const Center(child: Text('No crossword for today.'));
    }

    final canReveal = ref.read(crosswordsProvider.notifier).canRevealWords();

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
                    CrosswordGrid(puzzle: state.currentPuzzle!),
                    const SizedBox(height: 24),
                    if (canReveal)
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
                              .withOpacity(0.5),
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
                                  'Nitöngöni:',
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
                              "1. Ha hurufo fo'ösi. Talu'i dandra wamabali (-) ba tandra wamadö'ö ('). Duma-dumania: riŵi-riŵi tobali riwiriwi ba abo'a tobali aboa.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "2. Fuli'ö ba da'a dania ba zibongi. Tefa'ele'ö nösi sindruhu dahö-dahö aefa bözi 8!",
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
