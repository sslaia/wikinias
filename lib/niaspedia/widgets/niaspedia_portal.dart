import 'package:flutter/material.dart';
import 'package:wikinias/niaspedia/portals/portal_geography.dart';
import 'package:wikinias/niaspedia/portals/portal_government.dart';
import 'package:wikinias/niaspedia/portals/portal_history.dart';
import 'package:wikinias/niaspedia/portals/portal_maths.dart';
import 'package:wikinias/niaspedia/portals/portal_media.dart';
import 'package:wikinias/niaspedia/portals/portal_science.dart';

import '../../widgets/section_title.dart';
import '../../widgets/portal_text_button.dart';
import '../portals/portal_biology.dart';
import '../portals/portal_custom.dart';
import '../portals/portal_religion.dart';
import '../portals/portal_technology.dart';

class NiaspediaPortal extends StatelessWidget {
  const NiaspediaPortal({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        SectionTitle(label: 'portals', color: color),
        const SizedBox(height: 28.0),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              PortalTextButton(label: 'religion', color: color, destination: PortalReligion()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'biology', color: color, destination: PortalBiology()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'government', color: color, destination: PortalGovernment()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'geography', color: color, destination: PortalGeography()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'custom', color: color, destination: PortalCustom()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'maths', color: color, destination: PortalMaths()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'media', color: color, destination: PortalMedia()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'history', color: color, destination: PortalHistory()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'science', color: color, destination: PortalScience()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'technology', color: color, destination: PortalTechnology()),
            ],
          ),
        ),
      ],
    );
  }
}
