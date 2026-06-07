import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/crossword_model.dart';
import '../providers/crosswords_provider.dart';

class CrosswordGrid extends ConsumerStatefulWidget {
  final CrosswordPuzzle puzzle;
  final bool isFillable;

  const CrosswordGrid({
    super.key,
    required this.puzzle,
    this.isFillable = true,
  });

  @override
  ConsumerState<CrosswordGrid> createState() => _CrosswordGridState();
}

class _CrosswordGridState extends ConsumerState<CrosswordGrid> {
  int? selectedX;
  int? selectedY;
  CrosswordWord? selectedWord;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(crosswordsProvider);
    final size = widget.puzzle.gridSize;

    // Create a matrix to represent the grid
    // null means black cell, empty string means empty white cell, string means filled letter
    List<List<String?>> grid = List.generate(
      size,
      (_) => List.generate(size, (_) => null),
    );
    Map<String, int> wordNumbers = {};
    Map<String, String> correctMap = {};

    for (var i = 0; i < widget.puzzle.words.length; i++) {
      var word = widget.puzzle.words[i];
      wordNumbers['${word.x},${word.y}'] = i + 1;

      for (int j = 0; j < word.word.length; j++) {
        int cx = word.direction == 'across' ? word.x + j : word.x;
        int cy = word.direction == 'down' ? word.y + j : word.y;

        if (cx < size && cy < size) {
          grid[cy][cx] = state.userAnswers['$cx,$cy'] ?? '';
          correctMap['$cx,$cy'] = word.word[j].toUpperCase();
        }
      }
    }

    return TapRegion(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
        setState(() {
          selectedX = null;
          selectedY = null;
          selectedWord = null;
        });
      },
      child: Column(
        children: [
          if (selectedWord != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.shadow.withValues(alpha: 0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '${wordNumbers['${selectedWord!.x},${selectedWord!.y}']}. ${selectedWord!.clue}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size,
                  childAspectRatio: 1,
                ),
                itemCount: size * size,
                itemBuilder: (context, index) {
                  int x = index % size;
                  int y = index ~/ size;
                  String? cellValue = grid[y][x];

                  bool isBlack = cellValue == null;
                  bool isSelected = selectedX == x && selectedY == y;
                  bool isPartOfSelectedWord = false;

                  if (selectedWord != null) {
                    if (selectedWord!.direction == 'across') {
                      if (y == selectedWord!.y &&
                          x >= selectedWord!.x &&
                          x < selectedWord!.x + selectedWord!.word.length) {
                        isPartOfSelectedWord = true;
                      }
                    } else {
                      if (x == selectedWord!.x &&
                          y >= selectedWord!.y &&
                          y < selectedWord!.y + selectedWord!.word.length) {
                        isPartOfSelectedWord = true;
                      }
                    }
                  }

                  if (isBlack) {
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          selectedX = null;
                          selectedY = null;
                          selectedWord = null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            width: 0.5,
                          ),
                        ),
                      ),
                    );
                  }

                  bool isWrong = false;
                  if (cellValue.isNotEmpty &&
                      ref.read(crosswordsProvider.notifier).canRevealWords()) {
                    isWrong = cellValue.toUpperCase() != correctMap['$x,$y'];
                  }

                  final cellColor = isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : (isPartOfSelectedWord
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : Theme.of(context).colorScheme.surface);

                  final cellTextColor = isWrong
                      ? Theme.of(context).colorScheme.error
                      : (isSelected || isPartOfSelectedWord
                            ? Theme.of(context).colorScheme.onSecondaryContainer
                            : Theme.of(context).colorScheme.onSurface);

                  return GestureDetector(
                    onTap: () {
                      if (widget.isFillable) {
                        _handleCellTap(x, y);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: cellColor,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 0.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          if (wordNumbers.containsKey('$x,$y'))
                            Positioned(
                              top: 2,
                              left: 2,
                              child: Text(
                                wordNumbers['$x,$y'].toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          Center(
                            child: isSelected
                                ? TextField(
                                    autofocus: true,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: cellTextColor,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (val) {
                                      ref
                                          .read(crosswordsProvider.notifier)
                                          .setAnswer(x, y, val);
                                      _moveToNextCell();
                                    },
                                  )
                                : Text(
                                    cellValue,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: cellTextColor,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCellTap(int x, int y) {
    setState(() {
      selectedX = x;
      selectedY = y;

      // Find the word that contains this cell. Prefer 'across' if double tapped or if only one exists.
      List<CrosswordWord> matchingWords = [];
      for (var word in widget.puzzle.words) {
        if (word.direction == 'across') {
          if (y == word.y && x >= word.x && x < word.x + word.word.length) {
            matchingWords.add(word);
          }
        } else {
          if (x == word.x && y >= word.y && y < word.y + word.word.length) {
            matchingWords.add(word);
          }
        }
      }

      if (matchingWords.isNotEmpty) {
        if (matchingWords.length == 1) {
          selectedWord = matchingWords.first;
        } else {
          // toggle direction if clicking same cell
          if (selectedWord != null && matchingWords.contains(selectedWord)) {
            selectedWord = matchingWords.firstWhere((w) => w != selectedWord);
          } else {
            selectedWord = matchingWords.first;
          }
        }
      } else {
        selectedWord = null;
      }
    });
  }

  void _moveToNextCell() {
    if (selectedWord == null || selectedX == null || selectedY == null) return;

    setState(() {
      if (selectedWord!.direction == 'across') {
        if (selectedX! < selectedWord!.x + selectedWord!.word.length - 1) {
          selectedX = selectedX! + 1;
        }
      } else {
        if (selectedY! < selectedWord!.y + selectedWord!.word.length - 1) {
          selectedY = selectedY! + 1;
        }
      }
    });
  }
}
