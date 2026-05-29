import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wikimedia_core/wikimedia_core.dart';
import '../screens/article_screen.dart';
import 'app_state.dart';

class RandomArticleNotifier extends StateNotifier<bool> {
  RandomArticleNotifier() : super(false);

  Future<void> navigateToRandomArticle(BuildContext context, WidgetRef ref) async {
    state = true;
    try {
      final currentProject = ref.read(appStateProvider);
      final langCode = context.locale.languageCode;
      final projectStr = currentProject.name.toLowerCase();
      
      final randomTitle = await WikiApiService.fetchRandomArticleTitle(langCode, projectStr);
      
      if (randomTitle != null && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleScreen(title: randomTitle),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_fetching_random_article').tr()),
        );
      }
    } finally {
      state = false;
    }
  }
}

final randomArticleProvider = StateNotifierProvider<RandomArticleNotifier, bool>((ref) {
  return RandomArticleNotifier();
});
