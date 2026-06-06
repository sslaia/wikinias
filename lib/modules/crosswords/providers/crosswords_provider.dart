import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/crossword_model.dart';
import '../../../providers/shared_prefs_provider.dart';

class CrosswordsState {
  final List<CrosswordPuzzle> puzzles;
  final CrosswordPuzzle? currentPuzzle;
  final Map<String, String> userAnswers; // format "x,y": "letter"
  final Set<int> favoritePuzzles;
  final bool isLoading;
  final String? error;

  CrosswordsState({
    this.puzzles = const [],
    this.currentPuzzle,
    this.userAnswers = const {},
    this.favoritePuzzles = const {},
    this.isLoading = false,
    this.error,
  });

  CrosswordsState copyWith({
    List<CrosswordPuzzle>? puzzles,
    CrosswordPuzzle? currentPuzzle,
    Map<String, String>? userAnswers,
    Set<int>? favoritePuzzles,
    bool? isLoading,
    String? error,
  }) {
    return CrosswordsState(
      puzzles: puzzles ?? this.puzzles,
      currentPuzzle: currentPuzzle ?? this.currentPuzzle,
      userAnswers: userAnswers ?? this.userAnswers,
      favoritePuzzles: favoritePuzzles ?? this.favoritePuzzles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CrosswordsNotifier extends StateNotifier<CrosswordsState> {
  final Ref ref;

  CrosswordsNotifier(this.ref) : super(CrosswordsState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    await _loadFavorites();
    await _fetchData();
    _selectDailyPuzzle();
    _loadUserAnswers();
    state = state.copyWith(isLoading: false);
  }

  Future<void> _fetchData() async {
    List<CrosswordPuzzle> fetchedPuzzles = [];
    final prefs = ref.read(sharedPreferencesProvider);

    // Check if we need to sync today
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final lastSyncStr = prefs.getString('crossword_last_sync');
    bool shouldSync = lastSyncStr != todayStr;

    if (shouldSync) {
      try {
        final response = await http.get(
          Uri.parse(
            'https://raw.githubusercontent.com/sslaia/wikinias/refs/heads/main/assets/data/nias_crosswords.json',
          ),
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          fetchedPuzzles = data
              .map((json) => CrosswordPuzzle.fromJson(json))
              .toList();

          // Cache the downloaded JSON and update sync date
          await prefs.setString('cached_crosswords', response.body);
          await prefs.setString('crossword_last_sync', todayStr);
        } else {
          await _loadLocalData(prefs, fetchedPuzzles);
        }
      } catch (e) {
        // Fallback to cache or local assets on network error
        await _loadLocalData(prefs, fetchedPuzzles);
      }
    } else {
      // Load local data since we already synced today
      await _loadLocalData(prefs, fetchedPuzzles);
    }

    state = state.copyWith(puzzles: fetchedPuzzles);

    if (state.puzzles.isNotEmpty) {
      _selectDailyPuzzle();
      await _loadUserAnswers();
    }
  }

  Future<void> _loadLocalData(
    SharedPreferences prefs,
    List<CrosswordPuzzle> outList,
  ) async {
    final cachedStr = prefs.getString('cached_crosswords');
    if (cachedStr != null) {
      final List<dynamic> data = jsonDecode(cachedStr);
      outList.addAll(
        data.map((json) => CrosswordPuzzle.fromJson(json)).toList(),
      );
    } else {
      final jsonString = await rootBundle.loadString(
        'assets/data/nias_crosswords.json',
      );
      final List<dynamic> data = jsonDecode(jsonString);
      outList.addAll(
        data.map((json) => CrosswordPuzzle.fromJson(json)).toList(),
      );
    }
  }

  int get dailyPuzzleId {
    if (state.puzzles.isEmpty) return -1;
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(startOfYear).inDays + 1;
    return (dayOfYear % state.puzzles.length == 0)
        ? state.puzzles.length
        : dayOfYear % state.puzzles.length;
  }

  bool get isDailyPuzzleActive {
    return state.currentPuzzle?.puzzleId == dailyPuzzleId;
  }

  void _selectDailyPuzzle() {
    if (state.puzzles.isEmpty) return;
    final puzzle = state.puzzles.firstWhere(
      (p) => p.puzzleId == dailyPuzzleId,
      orElse: () => state.puzzles.first,
    );
    state = state.copyWith(currentPuzzle: puzzle);
  }

  Future<void> playDailyPuzzle() async {
    _selectDailyPuzzle();
    await _loadUserAnswers();
  }

  Future<void> playPuzzle(int puzzleId) async {
    final puzzle = state.puzzles.firstWhere(
      (p) => p.puzzleId == puzzleId,
      orElse: () => state.puzzles.first,
    );
    state = state.copyWith(currentPuzzle: puzzle);
    await _loadUserAnswers();
  }

  Future<void> _loadFavorites() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final favList = prefs.getStringList('crossword_favorites') ?? [];
    state = state.copyWith(favoritePuzzles: favList.map(int.parse).toSet());
  }

  Future<void> toggleFavorite() async {
    if (state.currentPuzzle == null) return;
    final currentId = state.currentPuzzle!.puzzleId;
    final favs = Set<int>.from(state.favoritePuzzles);

    if (favs.contains(currentId)) {
      favs.remove(currentId);
    } else {
      favs.add(currentId);
    }

    state = state.copyWith(favoritePuzzles: favs);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(
      'crossword_favorites',
      favs.map((e) => e.toString()).toList(),
    );
  }

  Future<void> _loadUserAnswers() async {
    if (state.currentPuzzle == null) return;
    final prefs = ref.read(sharedPreferencesProvider);
    final saved = prefs.getString(
      'crossword_answers_${state.currentPuzzle!.puzzleId}',
    );
    if (saved != null) {
      final Map<String, dynamic> decoded = jsonDecode(saved);
      state = state.copyWith(
        userAnswers: decoded.map((k, v) => MapEntry(k, v.toString())),
      );
    } else {
      state = state.copyWith(userAnswers: {});
    }
  }

  Future<void> setAnswer(int x, int y, String letter) async {
    if (state.currentPuzzle == null) return;
    final newAnswers = Map<String, String>.from(state.userAnswers);
    final key = '$x,$y';

    if (letter.isEmpty) {
      newAnswers.remove(key);
    } else {
      newAnswers[key] = letter.toUpperCase();
    }

    state = state.copyWith(userAnswers: newAnswers);

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      'crossword_answers_${state.currentPuzzle!.puzzleId}',
      jsonEncode(newAnswers),
    );

    _updateDailyScore();
  }

  void _updateDailyScore() {
    if (state.currentPuzzle == null) return;

    int correctLetters = 0;
    int totalLetters = 0;

    // Create a map of correct answers for easy lookup
    final correctMap = <String, String>{};
    for (var word in state.currentPuzzle!.words) {
      for (int i = 0; i < word.word.length; i++) {
        int cx = word.direction == 'across' ? word.x + i : word.x;
        int cy = word.direction == 'down' ? word.y + i : word.y;
        correctMap['$cx,$cy'] = word.word[i].toUpperCase();
      }
    }

    totalLetters = correctMap.length;
    correctMap.forEach((key, val) {
      if (state.userAnswers[key] == val) {
        correctLetters++;
      }
    });

    double score = totalLetters == 0 ? 0 : (correctLetters / totalLetters) * 10;
    final prefs = ref.read(sharedPreferencesProvider);
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    prefs.setDouble('crossword_score_$dateStr', score);
  }

  bool canRevealWords() {
    return DateTime.now().hour >= 20;
  }

  Future<void> revealWords() async {
    if (!canRevealWords() || state.currentPuzzle == null) return;

    final newAnswers = Map<String, String>.from(state.userAnswers);
    for (var word in state.currentPuzzle!.words) {
      for (int i = 0; i < word.word.length; i++) {
        int cx = word.direction == 'across' ? word.x + i : word.x;
        int cy = word.direction == 'down' ? word.y + i : word.y;
        newAnswers['$cx,$cy'] = word.word[i].toUpperCase();
      }
    }

    state = state.copyWith(userAnswers: newAnswers);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      'crossword_answers_${state.currentPuzzle!.puzzleId}',
      jsonEncode(newAnswers),
    );
  }

  Map<String, double> getScores() {
    final prefs = ref.read(sharedPreferencesProvider);
    final now = DateTime.now();

    double sumWeek = 0;
    int daysWeek = 0;
    // from monday to sunday
    int weekday = now.weekday; // 1 = monday, 7 = sunday
    for (int i = 0; i < weekday; i++) {
      final d = now.subtract(Duration(days: i));
      final ds =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      if (prefs.containsKey('crossword_score_$ds')) {
        sumWeek += prefs.getDouble('crossword_score_$ds')!;
        daysWeek++;
      }
    }

    double sumMonth = 0;
    int daysMonth = 0;
    for (int i = 0; i < now.day; i++) {
      final d = now.subtract(Duration(days: i));
      final ds =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      if (prefs.containsKey('crossword_score_$ds')) {
        sumMonth += prefs.getDouble('crossword_score_$ds')!;
        daysMonth++;
      }
    }

    double sumYear = 0;
    int daysYear = 0;
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    for (int i = 0; i < dayOfYear; i++) {
      final d = now.subtract(Duration(days: i));
      final ds =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      if (prefs.containsKey('crossword_score_$ds')) {
        sumYear += prefs.getDouble('crossword_score_$ds')!;
        daysYear++;
      }
    }

    return {
      'weekly': daysWeek == 0 ? 0 : sumWeek / daysWeek,
      'monthly': daysMonth == 0 ? 0 : sumMonth / daysMonth,
      'yearly': daysYear == 0 ? 0 : sumYear / daysYear,
    };
  }
}

final crosswordsProvider =
    StateNotifierProvider<CrosswordsNotifier, CrosswordsState>((ref) {
      return CrosswordsNotifier(ref);
    });
