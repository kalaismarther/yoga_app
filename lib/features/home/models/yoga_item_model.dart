class YogaItemModel {
  final int yogaId;
  final String name;
  final String imageLink;

  YogaItemModel(
      {required this.yogaId, required this.name, required this.imageLink});

  factory YogaItemModel.fromJson(Map<String, dynamic> json) => YogaItemModel(
      yogaId: int.parse(json['id']?.toString() ?? '0'),
      name: json['name'] ?? '',
      imageLink: json['is_icon_image'] ?? '');
}
