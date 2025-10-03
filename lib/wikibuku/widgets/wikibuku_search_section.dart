import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';
import '../wikibuku_search_results_screen.dart';

class WikibukuSearchSection extends StatefulWidget {
  const WikibukuSearchSection({super.key});

  @override
  State<WikibukuSearchSection> createState() => _WikibukuSearchSectionState();
}

class _WikibukuSearchSectionState extends State<WikibukuSearchSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: _searchController,
            decoration: InputDecoration(
              // hintText: 'search_wiki'.tr(),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                // Optional: adds a border
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0), // Spacing between TextField and Button
        ElevatedButton(
          onPressed: () {
            final query = _searchController.text;
            if (query.isNotEmpty) {
              // For Wikibooks search the results are directed to a webview page
              // to enable Nias language filter for the results
              // At least until API is available
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  WikibukuSearchResultsScreen(query: query),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: wbColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                0.0,
              ), // Set border radius to 0 for a square
            ),
          ),
          child: Text(
            'search_submit',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ).tr(),
        ),
      ],
    );
  }
}
