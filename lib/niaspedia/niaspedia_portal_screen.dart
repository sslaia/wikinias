import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/niaspedia/niaspedia_page_screen.dart';

class NiaspediaPortalScreen extends StatelessWidget {
  const NiaspediaPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleSmall
        ?.copyWith(color: Theme.of(context).colorScheme.primary);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
          title: Text(
            'portals'.tr(),
            style: titleStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: ListView(
            children: [
              ListTile(
                title: Text('portal_religion'.tr()),
                subtitle: Text('portal_religion_desc'.tr()),
                leading: Icon(Icons.church_outlined),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => NiaspediaPageScreen(title: 'Portal:Agama'),
                    ),
                  );
                }
              ),
              ListTile(
                  title: Text('biology'.tr()),
                  subtitle: Text('portal_biology_desc'.tr()),
                  leading: Icon(Icons.hive_outlined),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => NiaspediaPageScreen(title: 'Portal:Biologi'),
                      ),
                    );
                  }
              ),
              ListTile(
                  title: Text('portal_government'.tr()),
                  subtitle: Text('portal_government_desc'.tr()),
                  leading: Icon(Icons.account_balance_outlined),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => NiaspediaPageScreen(title: 'Portal:Famatörö'),
                      ),
                    );
                  }
              ),
              ListTile(
                  title: Text('portal_geography'.tr()),
                  subtitle: Text('portal_geography_desc'.tr()),
                  leading: Icon(Icons.landscape_outlined),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => NiaspediaPageScreen(title: 'Portal:Geografi'),
                      ),
                    );
                  }
              ),
              ListTile(
                  title: Text('portal_custom'.tr()),
                  subtitle: Text('portal_custom_desc'.tr()),
                  leading: Icon(Icons.person_outlined),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => NiaspediaPageScreen(title: 'Portal:Budaya'),
                      ),
                    );
                  }
              ),
              ListTile(
                  title: Text('portal_maths'.tr()),
                  subtitle: Text('portal_maths_desc'.tr()),
                  leading: Icon(Icons.functions_outlined),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => NiaspediaPageScreen(title: 'Portal:Matematika'),
                      ),
                    );
                  }
              ),
              ListTile(
                  title: Text('portal_media'.tr()),
                  subtitle: Text('portal_media_desc'.tr()),
                  leading: Icon(Icons.newspaper_outlined),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => NiaspediaPageScreen(title: 'Portal:Media'),
                      ),
                    );
                  }
              ),
              ListTile(
                  title: Text('portal_science'.tr()),
                  subtitle: Text('portal_science_desc'.tr()),
                  leading: Icon(Icons.science_outlined),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => NiaspediaPageScreen(title: 'Portal:Sains'),
                      ),
                    );
                  }
              ),
              ListTile(
                  title: Text('portal_history'.tr()),
                  subtitle: Text('portal_history_desc'.tr()),
                  leading: Icon(Icons.history_edu_outlined),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => NiaspediaPageScreen(title: 'Portal:Sejarah'),
                      ),
                    );
                  }
              ),
              ListTile(
                  title: Text('portal_technology'.tr()),
                  subtitle: Text('portal_technology_desc'.tr()),
                  leading: Icon(Icons.power_outlined),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => NiaspediaPageScreen(title: 'Portal:Teknologi'),
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
