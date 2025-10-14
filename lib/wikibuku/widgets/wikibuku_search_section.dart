import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../wikibuku_search_results_screen.dart';

class WikibukuSearchSection extends StatefulWidget {
  const WikibukuSearchSection({super.key});

  @override
  State<WikibukuSearchSection> createState() => _WikibukuSearchSectionState();
}

class _WikibukuSearchSectionState extends State<WikibukuSearchSection> {
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
                builder: (context) => WikibukuSearchResultsScreen(query: str),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
