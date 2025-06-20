class RegisterErrorModel {
  bool? status;
  String? message;
  Map<String, List<String>>? errors;

  RegisterErrorModel({this.status, this.message, this.errors});

  factory RegisterErrorModel.fromJson(Map<String, dynamic> json) {
    return RegisterErrorModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] != null
          ? Map<String, List<String>>.from(
              json['errors'].map((key, value) => MapEntry(key, List<String>.from(value))))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'errors': errors,
    };
  }
}
