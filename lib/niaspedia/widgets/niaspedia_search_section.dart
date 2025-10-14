import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../niaspedia_search_results_screen.dart';

class NiaspediaSearchSection extends StatefulWidget {
  const NiaspediaSearchSection({super.key});

  @override
  State<NiaspediaSearchSection> createState() => _NiaspediaSearchSectionState();
}

class _NiaspediaSearchSectionState extends State<NiaspediaSearchSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        onSubmitted: (String str) {
          if (str.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NiaspediaSearchResultsScreen(query: str),
              ),
            );
          }
        },
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          labelText: "search_what".tr(),
          labelStyle: TextStyle(fontSize: 10.0, color: Theme.of(context).colorScheme.tertiary),
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}
