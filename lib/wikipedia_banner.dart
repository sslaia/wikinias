import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WikipediaBanner extends StatelessWidget {
  const WikipediaBanner({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfffaf6ed),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      width: double.infinity,
      height: 200.0,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'wiki_banner_wp',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ).tr(),
          Text('wikinias_slogan',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ).tr(),
        ],
      ),
    );
  }
}