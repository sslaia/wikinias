import 'package:flutter/material.dart';
import 'package:wikinias/niaspedia/portals/portal_screen.dart';

import '../../widgets/featured_section_title.dart';
import '../../widgets/portal_text_button.dart';

class NiaspediaPortal extends StatelessWidget {
  const NiaspediaPortal({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeaturedSectionTitle(label: 'portals', color: color),
        const SizedBox(height: 28.0),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              PortalTextButton(label: 'religion', color: color, destination: PortalScreen(label: 'religion', title: 'Portal:Agama')),
              const SizedBox(width: 8),
              PortalTextButton(label: 'biology', color: color, destination: PortalScreen(label: 'biology', title: 'Portal:Biologi')),
              const SizedBox(width: 8),
              PortalTextButton(label: 'government', color: color, destination: PortalScreen(label: 'government', title: 'Portal:Famatörö')),
              const SizedBox(width: 8),
              PortalTextButton(label: 'geography', color: color, destination: PortalScreen(label: 'geography', title: 'Portal:Geografi')),
              const SizedBox(width: 8),
              PortalTextButton(label: 'custom', color: color, destination: PortalScreen(label: 'custom', title: 'Portal:Budaya')),
              const SizedBox(width: 8),
              PortalTextButton(label: 'maths', color: color, destination: PortalScreen(label: 'maths', title: 'Portal:Matematika')),
              const SizedBox(width: 8),
              PortalTextButton(label: 'media', color: color, destination: PortalScreen(label: 'media', title: 'Portal:Media')),
              const SizedBox(width: 8),
              PortalTextButton(label: 'history', color: color, destination: PortalScreen(label: 'history', title: 'Portal:Sejarah')),
              const SizedBox(width: 8),
              PortalTextButton(label: 'science', color: color, destination: PortalScreen(label: 'science', title: 'Portal:Sains')),
              const SizedBox(width: 8),
              PortalTextButton(label: 'technology', color: color, destination: PortalScreen(label: 'technology', title: 'Portal:Teknologi')),
            ],
          ),
        ),
      ],
    );
  }
}
