class LoginDataModel {
  bool? status;
  String? message;
  Data? data;
  String? token;
  Redirect? redirect;

  LoginDataModel(
      {this.status, this.message, this.data, this.token, this.redirect});

  LoginDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    token = json['token'];
    redirect =
        json['redirect'] != null ? Redirect.fromJson(json['redirect']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = token;
    if (redirect != null) {
      data['redirect'] = redirect!.toJson();
    }
    return data;
  }
}

class Data {
  String? memberProfileId;
  String? firstName;
  Null middleName;
  String? lastName;
  int? gender;
  String? dateOfBirth;
  int? caste;
  int? section;
  int? subsection;
  String? emailAddress;
  String? countryPhoneCode;
  String? mobileNumber;
  int? onBehalfId;
  Null maritalStatusId;

  Data(
      {this.memberProfileId,
      this.firstName,
      this.middleName,
      this.lastName,
      this.gender,
      this.dateOfBirth,
      this.caste,
      this.section,
      this.subsection,
      this.emailAddress,
      this.countryPhoneCode,
      this.mobileNumber,
      this.onBehalfId,
      this.maritalStatusId});

  Data.fromJson(Map<String, dynamic> json) {
    memberProfileId = json['member_profile_id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    caste = json['caste'];
    section = json['section'];
    subsection = json['subsection'];
    emailAddress = json['email_address'];
    countryPhoneCode = json['country_phone_code'];
    mobileNumber = json['mobile_number'];
    onBehalfId = json['on_behalf_id'];
    maritalStatusId = json['marital_status_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['member_profile_id'] = memberProfileId;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['caste'] = caste;
    data['section'] = section;
    data['subsection'] = subsection;
    data['email_address'] = emailAddress;
    data['country_phone_code'] = countryPhoneCode;
    data['mobile_number'] = mobileNumber;
    data['on_behalf_id'] = onBehalfId;
    data['marital_status_id'] = maritalStatusId;
    return data;
  }
}

class Redirect {
  Headers? headers;
  Original? original;
  Null exception;

  Redirect({this.headers, this.original, this.exception});

  Redirect.fromJson(Map<String, dynamic> json) {
    headers =
        json['headers'] != null ? Headers.fromJson(json['headers']) : null;
    original =
        json['original'] != null ? Original.fromJson(json['original']) : null;
    exception = json['exception'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (headers != null) {
      data['headers'] = headers!.toJson();
    }
    if (original != null) {
      data['original'] = original!.toJson();
    }
    data['exception'] = exception;
    return data;
  }
}

class Headers {
  Headers.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class Original {
  String? status;
  String? message;
  PageData? pageData;

  Original({this.status, this.message, this.pageData});

  Original.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    pageData =
        json['PageData'] != null ? PageData.fromJson(json['PageData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (pageData != null) {
      data['PageData'] = pageData!.toJson();
    }
    return data;
  }
}

class PageData {
  int? id;
  String? name;
  String? data;

  PageData({this.id, this.name, this.data});

  PageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['data'] = this.data;
    return data;
  }
}
