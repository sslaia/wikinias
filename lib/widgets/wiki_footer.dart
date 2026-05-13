import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/disclaimer.dart';
import '../data/license_notice.dart';
import 'spacer_image.dart';

class WikiFooter extends StatelessWidget {
  const WikiFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String disclaimerUrl = 'https://sslaia.github.io/wikinias/disclaimer.html';
    final String privacyPolicyUrl = 'https://sslaia.github.io/wikinias/privacy-policy.html';


    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          const SpacerImage(),
          const SizedBox(height: 16),
          Text(
            'WikiNias',
            style: GoogleFonts.cinzelDecorative(
              textStyle: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          HtmlWidget(
            '<div style="text-align: center;">$disclaimer</div>',
            textStyle: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 10,
              height: 1.6,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 24),
          HtmlWidget(
            '<div style="text-align: center;">$licenseNotice</div>',
            textStyle: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 10,
              height: 1.6,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterLink(
                label: 'Disclaimer',
                url: disclaimerUrl,
              ),
              const SizedBox(width: 16),
              _FooterLink(
                label: 'Privacy Policy',
                url: privacyPolicyUrl,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final String url;

  const _FooterLink({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () => launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppBrowserView,
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}