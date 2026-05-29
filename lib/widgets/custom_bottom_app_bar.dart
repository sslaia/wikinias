import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wikimedia_core/wikimedia_core.dart';
import 'adaptive_nav_actions.dart';

class CustomBottomAppBar extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ProjectType currentProject;
  final bool isHomeScreen;
  final String? pageTitle;

  const CustomBottomAppBar({
    super.key,
    required this.scaffoldKey,
    required this.currentProject,
    this.isHomeScreen = false,
    this.pageTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomAppBar(
      color: colorScheme.primary,
      height: 72,
      child: IconTheme(
        data: IconThemeData(color: colorScheme.onPrimary),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
            ),
            const SizedBox(width: 8),
            Text(
              'WikiNias',
              style: GoogleFonts.cinzelDecorative(
                textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            ...AdaptiveNavActions.buildActions(
              context, 
              ref, 
              currentProject: currentProject,
              isHomeScreen: isHomeScreen,
              pageTitle: pageTitle,
              showShortcuts: false,
            ),
          ],
        ),
      ),
    );
  }
}
