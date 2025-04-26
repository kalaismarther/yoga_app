import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/home/bloc/home_bloc.dart';
import 'package:yoga_app/features/home/models/yoga_item_model.dart';
import 'package:yoga_app/features/purchase/bloc/yoga_detail_bloc.dart';
import 'package:yoga_app/features/search/bloc/search_bloc.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class YogaItem extends StatelessWidget {
  const YogaItem({super.key, required this.yoga, required this.isHome});

  final YogaItemModel yoga;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    bool mobile = DeviceSize.screenWidth(context) < 576;
    return GestureDetector(
      onTap: () {
        if (isHome) {
          context.read<HomeBloc>().add(YogaItemClickedEvent());
        } else {
          context.read<SearchBloc>().add(SearchYogaItemClickedEvent());
        }

        context
            .read<YogaDetailBloc>()
            .add(GetYogaDetailEvent(courseId: yoga.yogaId));
      },
      child: Container(
        padding: EdgeInsets.all(mobile ? 14 : 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Theme.of(context).brightness == Brightness.light
              ? const Border()
              : Border.all(
                  width: 1, color: Theme.of(context).colorScheme.outline),
          boxShadow: [
            if (Theme.of(context).brightness == Brightness.light)
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                spreadRadius: 6,
                blurRadius: 8,
                offset: Offset.fromDirection(4, 1.0),
              )
          ],
        ),
        child: mobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: DeviceSize.screenWidth(context) * 0.14,
                    width: DeviceSize.screenWidth(context) * 0.14,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.primary),
                    child: Image.network(
                      yoga.imageLink,
                      height: DeviceSize.screenWidth(context) * 0.12,
                      width: DeviceSize.screenWidth(context) * 0.12,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Text(
                    yoga.name.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: DeviceSize.screenWidth(context) * 0.09,
                    width: DeviceSize.screenWidth(context) * 0.09,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.primary),
                    child: Image.network(
                      yoga.imageLink,
                      height: DeviceSize.screenWidth(context) * 0.1,
                      width: DeviceSize.screenWidth(context) * 0.1,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  Text(
                    yoga.name.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontSize: 17.5, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
      ),
    );
  }
}
