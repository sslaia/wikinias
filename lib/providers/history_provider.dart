import 'package:flutter_riverpod/legacy.dart';

class HistoryState {
  final List<String> stack;
  final int currentIndex;

  HistoryState({required this.stack, required this.currentIndex});

  bool get canGoBack => currentIndex > 0;
  bool get canGoForward => currentIndex < stack.length - 1;
  String? get currentTitle => stack.isNotEmpty ? stack[currentIndex] : null;

  HistoryState copyWith({List<String>? stack, int? currentIndex}) {
    return HistoryState(
      stack: stack ?? this.stack,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  HistoryNotifier() : super(HistoryState(stack: [], currentIndex: -1));

  void push(String title) {
    final List<String> currentStack = state.stack.sublist(0, state.currentIndex + 1);
    
    if (currentStack.isNotEmpty && currentStack.last == title) return;

    state = HistoryState(
      stack: [...currentStack, title],
      currentIndex: currentStack.length,
    );
  }

  String? goBack() {
    if (!state.canGoBack) return null;
    final prevTitle = state.stack[state.currentIndex - 1];
    state = state.copyWith(currentIndex: state.currentIndex - 1);
    return prevTitle;
  }

  String? goForward() {
    if (!state.canGoForward) return null;
    final nextTitle = state.stack[state.currentIndex + 1];
    state = state.copyWith(currentIndex: state.currentIndex + 1);
    return nextTitle;
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier();
});
