import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wikimedia_core/wikimedia_core.dart';
import '../screens/image_screen.dart';
import '../utils/wiki_utils.dart';
import '../utils/responsive_utils.dart';

class AdaptiveSectionCard extends StatelessWidget {
  final HomePageSection section;
  final ProjectType project;

  const AdaptiveSectionCard({
    super.key,
    required this.section,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompactPortrait = ResponsiveUtils.isCompact(context) && ResponsiveUtils.isPortrait(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            section.titleKey.tr(),
            style: GoogleFonts.montserratAlternates(
              textStyle: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 24),
          child: isCompactPortrait 
              ? _buildVerticalLayout(context) 
              : _buildHorizontalLayout(context),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout(BuildContext context) {
    final langCode = context.locale.languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.imageHtml != null)
          /// Make the image clickable on HomeScreen
          GestureDetector(
            onTap: () {
              if (section.imageUrl != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImageScreen(
                      imagePath: section.imageUrl!,
                    ),
                  ),
                );
              }
            },
            child: HtmlWidget(
              section.imageHtml!,
              onTapUrl: (url) => WikiUtils.handleTapUrl(context, url, null, project, langCode),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildBodyText(context),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(BuildContext context) {
    final langCode = context.locale.languageCode;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (section.imageHtml != null)
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                if (section.imageUrl != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageScreen(
                        imagePath: section.imageUrl!,
                      ),
                    ),
                  );
                }
              },
              child: Center(
                child: HtmlWidget(
                  section.imageHtml!,
                  onTapUrl: (url) => WikiUtils.handleTapUrl(context, url, null, project, langCode),
                ),
              ),
            ),
          ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildBodyText(context),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyText(BuildContext context) {
    final langCode = context.locale.languageCode;
    return HtmlWidget(
      section.textHtml,
      onTapUrl: (url) => WikiUtils.handleTapUrl(context, url, null, project, langCode),
      textStyle: GoogleFonts.notoSerif(
        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.6,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
      customStylesBuilder: (element) => WikiUtils.customStyles(context, element),
    );
  }
}
