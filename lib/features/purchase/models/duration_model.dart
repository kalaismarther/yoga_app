class DurationModel {
  final int id;
  final String name;
  final String duration;
  final String durationProductId;
  final String amount;
  final bool free;
  final bool trial;

  DurationModel(
      {required this.id,
      required this.name,
      required this.duration,
      required this.durationProductId,
      required this.amount,
      required this.free,
      required this.trial});

  factory DurationModel.fromJson(Map<String, dynamic> json) => DurationModel(
        id: int.parse(json['id']?.toString() ?? '0'),
        name: json['name']?.toString() ?? '',
        duration: json['duration']?.toString() ?? '',
        durationProductId: json['duration_product_id']?.toString() ?? '',
        amount: json['amount']?.toString() ?? '',
        free: json['class_type']?.toString() == '1',
        trial: json['free_class_type']?.toString() == '1',
      );
}
