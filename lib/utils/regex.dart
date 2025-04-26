class Regex {
  static final RegExp nameRegex = RegExp(r'^[a-zA-Z\s.]+$');
  static final RegExp numberRegex = RegExp(r'^\d+$');
  static final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
}
