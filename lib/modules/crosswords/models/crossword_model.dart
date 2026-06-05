class CrosswordWord {
  final String word;
  final String pageTitle;
  final String clue;
  final int x;
  final int y;
  final String direction; // "across" or "down"

  CrosswordWord({
    required this.word,
    required this.pageTitle,
    required this.clue,
    required this.x,
    required this.y,
    required this.direction,
  });

  factory CrosswordWord.fromJson(Map<String, dynamic> json) {
    return CrosswordWord(
      word: json['word'],
      pageTitle: json['page_title'],
      clue: json['clue'],
      x: json['x'],
      y: json['y'],
      direction: json['direction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'page_title': pageTitle,
      'clue': clue,
      'x': x,
      'y': y,
      'direction': direction,
    };
  }
}

class CrosswordPuzzle {
  final int puzzleId;
  final int gridSize;
  final List<CrosswordWord> words;

  CrosswordPuzzle({
    required this.puzzleId,
    required this.gridSize,
    required this.words,
  });

  factory CrosswordPuzzle.fromJson(Map<String, dynamic> json) {
    var wordList = json['words'] as List;
    return CrosswordPuzzle(
      puzzleId: json['puzzle_id'],
      gridSize: json['grid_size'],
      words: wordList.map((i) => CrosswordWord.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'puzzle_id': puzzleId,
      'grid_size': gridSize,
      'words': words.map((w) => w.toJson()).toList(),
    };
  }
}
