import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';
import '../niaspedia_search_results_screen.dart';

class NiaspediaSearchSection extends StatefulWidget {
  const NiaspediaSearchSection({
    super.key
  });

  @override
  State<NiaspediaSearchSection> createState() => _NiaspediaSearchSectionState();
}

class _NiaspediaSearchSectionState extends State<NiaspediaSearchSection> {
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
                  builder: (context) => NiaspediaSearchResultsScreen(query: query),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: npColor,
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
