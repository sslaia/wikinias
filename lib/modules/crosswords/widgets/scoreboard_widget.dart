import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/crosswords_provider.dart';

class ScoreboardWidget extends ConsumerWidget {
  const ScoreboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scores = ref.watch(crosswordsProvider.notifier).getScores();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.5),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'crossword_scoreboard'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bua nisöndra',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ScoreItem(
                    label: 'crossword_weekly'.tr(),
                    score: scores['weekly'] ?? 0.0,
                    icon: Icons.calendar_view_week,
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  _ScoreItem(
                    label: 'crossword_monthly'.tr(),
                    score: scores['monthly'] ?? 0.0,
                    icon: Icons.calendar_view_month,
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  _ScoreItem(
                    label: 'crossword_yearly'.tr(),
                    score: scores['yearly'] ?? 0.0,
                    icon: Icons.calendar_today,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String label;
  final double score;
  final IconData icon;

  const _ScoreItem({
    required this.label,
    required this.score,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(height: 8),
        Text(
          score.toStringAsFixed(1),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
