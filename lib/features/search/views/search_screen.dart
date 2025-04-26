import 'package:flutter/material.dart';
import 'package:yoga_app/features/search/views/search_mobile_layout.dart';
import 'package:yoga_app/features/search/views/search_tab_layout.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 576) {
          return const SearchMobileLayout();
        } else {
          return const SearchTabLayout();
        }
      },
    );
  }
}
