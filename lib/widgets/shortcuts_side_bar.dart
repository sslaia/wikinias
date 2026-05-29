import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wikimedia_core/wikimedia_core.dart';
import '../providers/app_state.dart';
import '../providers/shortcuts_provider.dart';
import '../utils/shortcut_utils.dart';

class ShortcutsSidebar extends ConsumerWidget {
  const ShortcutsSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentProject = ref.watch(appStateProvider);
    final langCode = context.locale.languageCode;
    final shortcutsAsync = ref.watch(shortcutsProvider);

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reuse the header style from your drawer or bottom sheet
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
            child: Text(
              'shortcuts'.tr(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: shortcutsAsync.when(
              data: (allShortcuts) {
                final projectKey =
                    currentProject.name.toLowerCase() == 'wikibooks' &&
                        langCode == 'id'
                    ? 'wikibuku'
                    : currentProject.name.toLowerCase();
                final langShortcuts =
                    allShortcuts[langCode] as Map<String, dynamic>?;
                final list =
                    (langShortcuts?[projectKey] as List<dynamic>?) ?? [];

                if (list.isEmpty) return const SizedBox.shrink();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final shortcut = list[index] as Map<String, dynamic>;
                    return _buildShortcutCard(
                      context,
                      theme,
                      currentProject,
                      langCode,
                      shortcut,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('${'error'.tr()}: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutCard(
    BuildContext context,
    ThemeData theme,
    ProjectType currentProject,
    String currentLanguage,
    Map<String, dynamic> s,
  ) {
    final iconName = s['icon'] as String;
    final title = s['title'] as String;
    final pageTitle = s['pageTitle'] as String;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await ShortcutUtils.handleShortcutTap(
              context,
              pageTitle,
              currentLanguage,
              currentProject,
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: currentProject.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    ShortcutUtils.getIconData(iconName),
                    size: 18,
                    color: currentProject.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
