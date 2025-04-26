class ApiUrl {
  //http://60myoga.com/yoga/
  //http://18.189.69.82/yoga/
  static const String _base = "http://60myoga.com/yoga/";
  static const String _apiUrl = "${_base}api/";

  //
  static const String aboutUs = "${_base}about_us";
  static const String terms = "${_base}terms_condition";
  static const String privacyPolicy = "${_base}privacy_policy";

  //
  static const String walkThrough = "${_apiUrl}walkthrough_list";
  static const String helpandsupport = "${_apiUrl}get_help_support";
  static const String getTestimonials = "${_apiUrl}get_testimonials";

  //Auth
  static const String login = "${_apiUrl}login";
  static const String verifyOtp = "${_apiUrl}verify_otp";
  static const String verifyOtpEdit = "${_apiUrl}verify_otp_edit";
  static const String resendOtp = "${_apiUrl}resend_otp";
  static const String deleteAccountUrl = "${_apiUrl}delete_user";

  //Home
  static const String yogaCoursesUrl = "${_apiUrl}yoga_class";
  static const String getNotificationsUrl =
      "${_apiUrl}get_notifications_latest";

  //Search
  static const String searchYogaUrl = "${_apiUrl}yogaclass_search";

  //Purchase
  static const String yogaDetail = "${_apiUrl}yoga_detail";
  static const String confirmBooking = "${_apiUrl}booking_summary";
  static const String myBookingsList = "${_apiUrl}my_bookings_list";
  static const String myBookingDetail = "${_apiUrl}my_booking_detail";
  static const String updatePayment = "${_apiUrl}razorpay_payment";

  //Switch
  static const String switchOverClass = "${_apiUrl}switch_overclass";

  //Profile
  static const String updateProfile = "${_apiUrl}update_profile";
  static const String editProfile = "${_apiUrl}profile_edit";
  static const String updateProfileImage = "${_apiUrl}update_profile_image";

  //
  static const String logout = "${_apiUrl}logout";

  static const String deleteIcon = '${_apiUrl}delete_icon';
}
