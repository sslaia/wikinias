import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/app_bar/bottom_app_bar_label_button.dart';
import 'package:wikinias/app_bar/drawer_about_section.dart';
import 'package:wikinias/app_bar/drawer_font_selection_section.dart';
import 'package:wikinias/app_bar/drawer_header_container.dart';
import 'package:wikinias/app_bar/drawer_language_selection_section.dart';
import 'package:wikinias/app_bar/drawer_project_selection_section.dart';
import 'package:wikinias/app_bar/drawer_update_service_section.dart';
import 'package:wikinias/app_bar/home_icon_button.dart';
import 'package:wikinias/app_bar/refresh_icon_button.dart';
import 'package:wikinias/app_bar/wikinias_bottom_app_bar.dart';
import 'package:wikinias/app_bar/wikinias_drawer_menu.dart';
import 'package:wikinias/courses/courses_page.dart';
import 'package:wikinias/models/courses_content_item.dart';
import 'package:wikinias/services/app_data_service.dart';
import 'package:wikinias/widgets/flexible_page_header.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late Future<List<CoursesContentItem>> _futureCourses;

  @override
  void initState() {
    super.initState();
    final appData = Provider.of<AppDataService>(context, listen: false);
    _futureCourses = appData.loadCoursesData();
  }

  @override
  Widget build(BuildContext context) {
    // BottomAppBar configuration
    final List<Widget> barChildren = [
      // OpenDrawerButton(),
      BottomAppBarLabelButton(label: 'courses'),
      const Spacer(),
      HomeIconButton(),
      RefreshIconButton(destination: CoursesScreen()),
    ];

    // MenuDrawer items
    final List<Widget> drawerChildren = [
      DrawerHeaderContainer(),
      // CoursesDrawerSection(),
      DrawerProjectSelectionSection(),
      DrawerLanguageSelectionSection(),
      DrawerFontSelectionSection(),
      DrawerUpdteServiceSection(),
      DrawerAboutSection(),
    ];

    final TextStyle? titleStyle = Theme.of(context).textTheme.titleMedium
        ?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
        );

    return SafeArea(
      child: Scaffold(
        drawer: Builder(
          builder: (drawerContext) {
            return WikiniasDrawerMenu(children: drawerChildren);
          },
        ),
        bottomNavigationBar: WikiniasBottomAppBar(children: barChildren),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'courses'.tr(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              floating: true,
              expandedHeight: 250,
              flexibleSpace: FlexiblePageHeader(
                image: "assets/images/ni'owulurai.webp",
              ),
            ),
            FutureBuilder<List<CoursesContentItem>>(
              future: _futureCourses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(child: Text("Error: ${snapshot.error}")),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final course = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: ListTile(
                        title: Text(course.title),
                        titleTextStyle: titleStyle,
                        subtitle: Text(
                          course.text,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text('courses_${course.category}'.tr()),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) =>
                                  CoursesPage(title: course.title),
                            ),
                          );
                          // launchUrl(Uri.parse(course.url));
                        },
                      ),
                    );
                  }, childCount: snapshot.data!.length),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
