import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../wikikamus_search_results_screen.dart';

class WikikamusSearchSection extends StatefulWidget {
  const WikikamusSearchSection({
    super.key
  });

  @override
  State<WikikamusSearchSection> createState() => _WikikamusSearchSectionState();
}

class _WikikamusSearchSectionState extends State<WikikamusSearchSection> {
    final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
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
        const SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: () {
            final query = _searchController.text;
            if (query.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WikikamusSearchResultsScreen(
                    query: query,
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            // backgroundColor: Color(0xffe9d6ae),
            foregroundColor: Colors.deepOrange,
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
