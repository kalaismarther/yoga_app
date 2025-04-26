class TimeSlotModel {
  final int id;
  final String timing;

  TimeSlotModel({required this.id, required this.timing});

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) => TimeSlotModel(
      id: int.parse(json['id']?.toString() ?? '0'),
      timing: json['name']?.toString() ?? '');
}
