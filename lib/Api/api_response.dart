class ApiResponse {
  const ApiResponse(
      {required this.success, required this.data, this.errorMessage});

  final bool success;
  final Map<String, dynamic> data;
  final String? errorMessage;
}
