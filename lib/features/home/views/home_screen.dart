import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/home/bloc/home_bloc.dart';
import 'package:yoga_app/features/home/views/home_mobile_layout.dart';
import 'package:yoga_app/features/home/views/home_tab_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeInitialEvent()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 576) {
            return const HomeMobileLayout();
          } else {
            return const HomeTabLayout();
          }
        },
      ),
    );
  }
}
