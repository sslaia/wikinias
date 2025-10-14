import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'create_new_page_introduction.dart';

class CreateNewPageForm extends StatefulWidget {
  const CreateNewPageForm({super.key, required this.url});

  final String url;

  @override
  State<CreateNewPageForm> createState() => _CreateNewPageFormState();
}

class _CreateNewPageFormState extends State<CreateNewPageForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    final double bodyFontSize =
        Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("create_new_page", style: TextStyle(color: color, fontSize: bodyFontSize * 1.0)).tr(),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlWidget(createNewPageIntroduction),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _titleController,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                      labelText: "enter_title_here".tr(),
                      labelStyle: TextStyle(fontSize: 10.0),
                      errorText: _titleController.text.isEmpty
                          ? null
                          : "enter_new_title_here".tr(),
                      // hintText: 'search_wiki'.tr(),
                      prefixIcon: Icon(Icons.create),
                      border: OutlineInputBorder(
                        // Optional: adds a border
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "enter_title_please".tr();
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    String title = _titleController.text.toLowerCase();
                    String capitalizedTitle = title.split(" ").map((word) => word.capitalize()).join(" ");
                    if (_formKey.currentState?.validate() ?? false) {
                      // Open the link in an external browser
                      launchUrl(Uri.parse('${widget.url}$capitalizedTitle?action=edit&section=all'));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        0.0,
                      ), // Set border radius to 0 for a square
                    ),
                  ),
                  child: Text(
                    'create_submit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                  ).tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
