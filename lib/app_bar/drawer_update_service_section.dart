import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wikinias/services/app_data_service.dart';

class DrawerUpdteServiceSection extends StatefulWidget {
  const DrawerUpdteServiceSection({super.key});

  @override
  State<DrawerUpdteServiceSection> createState() =>
      _DrawerUpdteServiceSectionState();
}

class _DrawerUpdteServiceSectionState extends State<DrawerUpdteServiceSection> {
  // We only need one state variable to manage the loading indicator
  bool _isUpdating = false;

  // We'll keep track of the last update time to display it to the user.
  String _lastUpdateTime = 'never';

  @override
  void initState() {
    super.initState();
    _loadLastUpdateTime();
  }

  // A simplified method to get the most recent update time from any of the configs.
  Future<void> _loadLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    int mostRecentUpdate = 0;

    // Check the timestamp for each config file
    for (final config in AppDataService.allConfigs) {
      final key = '${config.cacheKey}_last_update';
      final timestamp = prefs.getInt(key) ?? 0;
      if (timestamp > mostRecentUpdate) {
        mostRecentUpdate = timestamp;
      }
    }

    setState(() {
      if (mostRecentUpdate == 0) {
        _lastUpdateTime = 'never'.tr();
      } else {
        // Format the date nicely for the user
        final date = DateTime.fromMillisecondsSinceEpoch(mostRecentUpdate);
        _lastUpdateTime = DateFormat.yMMMd().add_jms().format(date);
      }
    });
  }

  // The single method to trigger the update for everything.
  Future<void> _forceUpdateAllContent() async {
    // Prevent multiple clicks while updating
    if (_isUpdating) return;

    final appDataService = Provider.of<AppDataService>(context, listen: false);

    setState(() {
      _isUpdating = true;
    });

    // Show feedback to the user immediately.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('checking_for_updates'.tr()),
        duration: const Duration(seconds: 3),
      ),
    );

    await appDataService.forceUpdate();

    // After the update logic completes, refresh the "last updated" time and stop the indicator.
    await _loadLastUpdateTime();
    if (mounted) {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(
        'content_update_service'.tr(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: 'Gelasio',
          fontWeight: FontWeight.w700,
        ),
      ),
      children: [
        ListTile(
          leading: _isUpdating
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.0),
          )
              : const Icon(Icons.sync),
          title: Text('force_content_update'.tr()),
          subtitle: Text('${'last_update'.tr()}: $_lastUpdateTime'),
          onTap: _forceUpdateAllContent, // Call the single update function
        ),
      ],
    );
  }
}
