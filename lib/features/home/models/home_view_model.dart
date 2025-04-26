import 'package:yoga_app/features/home/models/yoga_item_model.dart';

class HomeViewModel {
  final String userName;
  final List<YogaItemModel> yogaCoursesList;

  HomeViewModel({required this.userName, required this.yogaCoursesList});
}
