import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/title_api_service.dart';

typedef InternalLinkCallback = void Function(String title);

class RandomIconButton extends StatefulWidget {
  const RandomIconButton({
    super.key,
    required this.project,
    required this.color,
    required this.onRandomTitleFound,
  });

  final String project;
  final Color color;
  final InternalLinkCallback onRandomTitleFound;

  @override
  State<RandomIconButton> createState() => _RandomIconButtonState();
}

class _RandomIconButtonState extends State<RandomIconButton> {
  Map<String, List<String>>? _allTitles;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeTitles();
  }

  Future<void> _initializeTitles() async {
    if (!_isLoading) setState(() => _isLoading = true);

    final titleService = Provider.of<TitleApiService>(context, listen: false);

    try {
      final loadedTitles = await titleService.loadTitles();
      if (mounted) {
        setState(() {
          _allTitles = loadedTitles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load random title data.')),
        );
      }
    }
  }

  void _showRandomTitle() {
    if (_allTitles == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title data not ready.')),
      );
      return;
    }

    final titleService = Provider.of<TitleApiService>(context, listen: false);
    final randomTitle = titleService.getRandomTitle(_allTitles!, widget.project);

    if (randomTitle != null) {
      widget.onRandomTitleFound (randomTitle);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No titles found for project: ${widget.project}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: widget.color,
          strokeWidth: 2.0,
        ),
      );
    }
    return IconButton(
      tooltip: 'random'.tr(),
      icon: const Icon(Icons.shuffle_outlined),
      color: widget.color,
      onPressed: _allTitles == null ? null : _showRandomTitle,
    );
  }
}
