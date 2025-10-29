import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/providers/settings_provider.dart';
import 'package:wikinias/services/wikinias_api_service.dart';

// Callback to navigate when a page is tapped in the dialog
typedef InternalLinkCallback = void Function(String title);

class RandomIconButton extends StatefulWidget {
  const RandomIconButton({super.key, required this.onRandomTitleFound});

  final InternalLinkCallback onRandomTitleFound;

  @override
  State<RandomIconButton> createState() => _RandomIconButtonState();
}

class _RandomIconButtonState extends State<RandomIconButton> {
  bool _isLoading = false;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  Future<void> _findAndNavigateToRandomPage() async {
    // Prevent multiple clicks while loading.
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    try {
      // Get the API URL from settings (e.g., for Wikipedia or Wiktionary)
      final projectApiUrl = settingsProvider.getProjectApiUrl();

      // Fetch a single random title.
      final String? randomTitle = await _wikiApiService.fetchSingleRandomTitle(projectApiUrl: projectApiUrl);

      if (mounted && randomTitle != null) {
        // Use the callback to navigate immediately.
        widget.onRandomTitleFound(randomTitle);
      } else if (mounted) {
        // Handle case where no title was returned
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not find a random page.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      // Always stop loading.
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'random'.tr(),
      // Show loading indicator or icon
      icon: _isLoading
          ? SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      )
          : const Icon(Icons.shuffle_outlined),
      color: Theme.of(context).colorScheme.primary,
      onPressed: _findAndNavigateToRandomPage, // Calls the new async function
    );
  }
}
