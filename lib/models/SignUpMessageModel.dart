class SignUpMessageModel {
  late int statusCode;
  late String message;

  // late var data;

  SignUpMessageModel({
    required this.statusCode,
    required this.message,
  });

  factory SignUpMessageModel.fromJson(Map<String, dynamic> json) {
    return SignUpMessageModel(statusCode: json['status'], message: json['message']);
  }
}
