import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class DrawerProjectSelectionSection extends StatelessWidget {
  const DrawerProjectSelectionSection({super.key, required this.project});

  final String project;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        initiallyExpanded: true,
        title: Text('projects', style: titleStyle).tr(),
        children: [
          ListTile(
            leading: Icon(Icons.language_outlined, color: Color(0xff121298)),
            title: Text('Niaspedia', style: itemStyle),
            trailing: (project == 'Niaspedia') ? Icon(Icons.done) : null,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.translate_outlined, color: Colors.deepOrange),
            title: Text('Wikikamus', style: itemStyle),
            trailing: (project == 'Wikikamus') ? Icon(Icons.done) : null,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/wikikamus');
            },
          ),
          ListTile(
            leading: Icon(Icons.menu_book_outlined, color: Color(0xff9b00a1)),
            title: Text('Wikibuku', style: itemStyle),
            trailing: (project == 'Wikibuku') ? Icon(Icons.done) : null,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/wikibuku');
            },
          ),
          ListTile(
            leading: Icon(Icons.school_outlined, color: Colors.deepOrange,),
            title: Text('courses', style: itemStyle).tr(),
            trailing: (project == 'Courses') ? Icon(Icons.done) : null,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/courses');
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library_outlined, color: Color(0xff121298)),
            title: Text('gallery', style: itemStyle).tr(),
            trailing: (project == 'Gallery') ? Icon(Icons.done) : null,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/gallery');
            },
          ),
        ],
    );
  }
}
