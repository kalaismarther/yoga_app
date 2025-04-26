class LoginRequestModel {
  final String mobileNo;

  LoginRequestModel({required this.mobileNo});

  //

  Map<String, dynamic> toJson() => {"login_id": mobileNo};
}
