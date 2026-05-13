import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project_type.dart';
import '../providers/app_state.dart';
import '../providers/random_article_provider.dart';
import '../providers/wiki_api_provider.dart';
import '../services/wiki_api_service.dart';
import 'shortcuts_bottom_sheet.dart';

class NavAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  NavAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });
}

class AdaptiveNavActions {
  static List<NavAction> getActions(BuildContext context, WidgetRef ref, {
    required ProjectType currentProject,
    required bool isHomeScreen,
    bool showHome = true,
    bool showShortcuts = true,
    String? pageTitle,
  }) {
    final isFetchingRandom = ref.watch(randomArticleProvider);

    return [
      if (showHome)
        NavAction(
          icon: Icons.home,
          label: 'home'.tr(),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      NavAction(
        icon: Icons.refresh,
        label: 'refresh'.tr(),
        onPressed: () async {
          final langCode = ref.read(languageProvider);
          await WikiApiService.clearCache(
            currentProject, 
            langCode, 
            isHomeScreen ? null : pageTitle
          );
          
          final targetTitle = isHomeScreen ? null : pageTitle;
          ref.invalidate(wikiApiProvider(targetTitle));
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('refreshing_content').tr(),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
      ),
      if (showShortcuts)
      NavAction(
        icon: Icons.switch_access_shortcut_outlined,
        label: 'shortcuts'.tr(),
        onPressed: () {
          showShortcutsBottomSheet(context, ref);
        },
      ),
      NavAction(
        icon: Icons.shuffle,
        label: 'random'.tr(),
        isLoading: isFetchingRandom,
        onPressed: () => ref.read(randomArticleProvider.notifier).navigateToRandomArticle(context, ref),
      ),
    ];
  }

  static List<Widget> buildActions(BuildContext context, WidgetRef ref, {
    required ProjectType currentProject,
    required bool isHomeScreen,
    bool showHome = true,
    bool showShortcuts = true,
    String? pageTitle,
    Color? color,
  }) {
    final actions = getActions(
      context, 
      ref, 
      currentProject: currentProject, 
      isHomeScreen: isHomeScreen,
      showHome: showHome,
      showShortcuts: showShortcuts,
      pageTitle: pageTitle
    );

    return actions.map((action) {
      if (action.isLoading) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: color ?? Colors.white,
            ),
          ),
        );
      }
      return IconButton(
        icon: Icon(action.icon),
        color: color,
        onPressed: action.onPressed,
        tooltip: action.label,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      );
    }).toList();
  }
}
