class TestimonialModel {
  final int id;
  final String customerProfile;
  final String customerName;
  final String description;
  final String videoUrl;

  TestimonialModel(
      {required this.id,
      required this.customerProfile,
      required this.customerName,
      required this.description,
      required this.videoUrl});

  factory TestimonialModel.fromJson(Map<String, dynamic> json) =>
      TestimonialModel(
        id: int.parse(json['id']?.toString() ?? '0'),
        customerProfile: json['is_image']?.toString() ?? '',
        customerName: json['name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        videoUrl: json['is_video']?.toString() ?? '',
      );
}
