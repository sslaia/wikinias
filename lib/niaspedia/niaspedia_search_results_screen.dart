import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/create_new_page_form.dart';
import '../widgets/create_new_page_icon_button.dart';
import '../models/search_result.dart';
import '../services/search_api_service.dart';
import 'niaspedia_page_screen.dart';
import '../constants.dart';

class NiaspediaSearchResultsScreen extends StatefulWidget {
  final String query;

  const NiaspediaSearchResultsScreen({super.key, required this.query});

  @override
  State<NiaspediaSearchResultsScreen> createState() =>
      _NiaspediaSearchResultsScreenState();
}

class _NiaspediaSearchResultsScreenState
    extends State<NiaspediaSearchResultsScreen> {

  final SearchApiService _searchApiService =
      SearchApiService(); // Instance of the service
  List<SearchResult> _searchResults = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final results = await _searchApiService.searchNiaspedia(widget.query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'search_error_occurred: $e'.tr();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: npColor),
          title: Text('search_results', style: TextStyle(color: npColor)).tr(),
          actions: [
            CreateNewPageIconButton(label: 'create_new_page', destination: CreateNewPageForm(url: npUrl, color: npColor), color: npColor),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
            ? Center(
                child: Text(_error, style: TextStyle(color: Colors.red)),
              )
            : _searchResults.isEmpty
            ? Center(child: Text('search_no_results').tr())
            : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  final title = result.title;
                  final snippet = result.snippet.replaceAll(
                    RegExp(r'<[^>]*>'),
                    '',
                  ); // Basic HTML tag removal

                  return ListTile(
                    title: Text(title),
                    subtitle: Text(
                      snippet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // Navigate to PageScreen with the title
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NiaspediaPageScreen(title: title),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
