import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/home/components/yoga_item.dart';
import 'package:yoga_app/features/home/models/yoga_item_model.dart';
import 'package:yoga_app/features/purchase/views/yoga_detail_screen.dart';
import 'package:yoga_app/features/search/bloc/search_bloc.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';
import 'package:yoga_app/widgets/no_internet.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class SearchTabLayout extends StatefulWidget {
  const SearchTabLayout({super.key});

  @override
  State<SearchTabLayout> createState() => _SearchTabLayoutState();
}

class _SearchTabLayoutState extends State<SearchTabLayout> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    _searchFocus.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool lightMode = Theme.of(context).brightness == Brightness.light;
    return BlocConsumer<SearchBloc, SearchState>(
      listenWhen: (previous, current) => current is SearchNavigationState,
      buildWhen: (previous, current) => current is! SearchNavigationState,
      listener: (context, state) {
        if (state is SearchYogaItemClickedState) {
          _searchFocus.unfocus();
          Nav.push(context, const YogaDetailScreen());
        }
      },
      builder: (context, state) {
        return Container(
          color: Theme.of(context).colorScheme.shadow,
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      if (lightMode)
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          spreadRadius: 6,
                          blurRadius: 20,
                          offset: Offset.fromDirection(1.5, 16.0),
                        )
                    ],
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    style: const TextStyle(fontSize: 26),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      constraints: BoxConstraints(
                        minWidth: 50,
                        maxWidth: DeviceSize.screenWidth(context) * 0.66,
                        minHeight: 70,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Image.asset(
                          AppImages.lens,
                          height: 32,
                        ),
                      ),
                      hintText: 'Search',
                      hintStyle: Theme.of(context)
                          .inputDecorationTheme
                          .hintStyle!
                          .copyWith(fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: lightMode
                            ? BorderSide.none
                            : BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: lightMode
                            ? BorderSide.none
                            : BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<SearchBloc>().add(
                          SearchYogaEvent(keyword: _searchController.text));
                    },
                  ),
                ),
                const VerticalSpace(height: 30),
                if (state is SearchLoadingState)
                  GridView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.44,
                            crossAxisCount: 3,
                            crossAxisSpacing: 34,
                            mainAxisSpacing: 34),
                    itemBuilder: (context, index) => Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Theme.of(context).colorScheme.brightness ==
                                Brightness.light
                            ? const Border()
                            : Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.outline),
                      ),
                      child: LoadingShimmer(
                        height: double.infinity,
                        width: double.infinity,
                        baseColor: Theme.of(context).colorScheme.tertiary,
                        highlightColor:
                            Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  )
                else if (state is SearchSuccessState)
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.data.yogaList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.44,
                      crossAxisCount: 3,
                      crossAxisSpacing: 34,
                      mainAxisSpacing: 34,
                    ),
                    itemBuilder: (context, index) => YogaItem(
                      yoga: YogaItemModel.fromJson(state.data.yogaList[index]),
                      isHome: false,
                    ),
                  )
                else if (state is SearchFailureState)
                  Text(state.error.reason)
                else if (state is SearchNetworkErrorState)
                  const NoInternet(),
                const VerticalSpace(height: 28),
              ],
            ),
          ),
        );
      },
    );
  }
}
