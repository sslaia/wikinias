import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wikimedia_core/wikimedia_core.dart';
import '../providers/app_state.dart';
import '../providers/shortcuts_provider.dart';
import '../utils/shortcut_utils.dart';

void showShortcutsBottomSheet(BuildContext context, WidgetRef ref) {
  final theme = Theme.of(context);
  final currentProject = ref.read(appStateProvider);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (builderContext) {
      return Consumer(
        builder: (consumerContext, ref, child) {
          final langCode = context.locale.languageCode;
          final shortcutsAsync = ref.watch(shortcutsProvider);

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: currentProject.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'drawer_quick_shortcuts'.tr().toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: currentProject.primaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'shortcuts'.tr(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                          fontSize: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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

                      if (list.isEmpty) {
                        return _buildEmptyState(theme);
                      }

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
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text('${'error'.tr()}: $err'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildShortcutCard(
  BuildContext context,
  ThemeData theme,
  ProjectType project,
  String langCode,
  Map<String, dynamic> shortcut,
) {
  final iconName = shortcut['icon'] as String;
  final title = shortcut['title'] as String;
  final pageTitle = shortcut['pageTitle'] as String;

  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
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
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: project.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            ShortcutUtils.getIconData(iconName),
            size: 20,
            color: project.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        onTap: () async {
          Navigator.pop(context);
          await ShortcutUtils.handleShortcutTap(
            context,
            pageTitle,
            langCode,
            project,
          );
        },
      ),
    ),
  );
}

Widget _buildEmptyState(ThemeData theme) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.auto_awesome_motion_rounded,
          size: 48,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        const SizedBox(height: 16),
        Text(
          'no_shortcuts_available'.tr(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ],
    ),
  );
}
