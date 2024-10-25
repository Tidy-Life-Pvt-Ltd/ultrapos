import '../utils/constants.dart';

class LoginResponse {
  final String? result;
  final String? filePrefix;
  LoginContent? loginContent;

  LoginResponse({this.result, this.filePrefix, this.loginContent});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return (json['content'] != null
        ? LoginResponse(
            result: json["result"],
            filePrefix:
                json.containsKey("files_prefix") ? json["files_prefix"] : "",
            loginContent: LoginContent.fromJson(json['content']))
        : LoginResponse(result: Constants.errorPsswordIncorret));
  }
}

class LoginContent {
  final String token;
  final LoginPartner loginPartner;

  LoginContent({required this.token, required this.loginPartner});

  factory LoginContent.fromJson(Map<String, dynamic> json) {
    return LoginContent(
        token: json["token"],
        loginPartner: LoginPartner.fromJson(json['partner']));
  }
}

class LoginPartner {
  final int id;
  final String name;
  final String companyName;
  final String email;
  final LoginMoreInfo loginMoreInfo;

  LoginPartner(
      {required this.id,
      required this.name,
      required this.companyName,
      required this.email,
      required this.loginMoreInfo});

  factory LoginPartner.fromJson(Map<String, dynamic> json) {
    return LoginPartner(
        id: json["id"],
        name: json["name"],
        companyName: json["company_name"],
        email: json["email"],
        loginMoreInfo: LoginMoreInfo.fromJson(json['moreInfo']));
  }
}

class LoginMoreInfo {
  final String phoneNumber;
  final LoginLocation loginLocation;
  final List<LoginPeriods> loginPeriodsList;

  LoginMoreInfo(
      {required this.phoneNumber,
      required this.loginPeriodsList,
      required this.loginLocation});

  factory LoginMoreInfo.fromJson(Map<String, dynamic> json) {
    return LoginMoreInfo(
        phoneNumber: json["phone_number"] != null ? json["phone_number"] : "",
        loginLocation: LoginLocation.fromJson(json['location']),
        loginPeriodsList: List<LoginPeriods>.from(
            json["periods"].map((x) => LoginPeriods.fromJson(x))));
  }
}

class LoginLocation {
  final String name;
  final String city_id;

  LoginLocation({required this.name, required this.city_id});

  factory LoginLocation.fromJson(Map<String, dynamic> json) {
    return LoginLocation(name: json["name"], city_id: json["city_id"]);
  }
}

class LoginPeriods {
  final int id;
  final String fromTime;
  final String toTime;
  final String periodName;
  final String periodTime;
  final String day;
  final String month;

  LoginPeriods(
      {required this.id,
      required this.fromTime,
      required this.toTime,
      required this.periodName,
      required this.periodTime,
      required this.day,
      required this.month});

  factory LoginPeriods.fromJson(Map<String, dynamic> json) {
    return LoginPeriods(
      id: json["id"],
      fromTime: json["from_time"],
      toTime: json["to_time"],
      periodName: json["period_name"],
      periodTime: json["period_time"],
      day: json["day"],
      month: json["month"],
    );
  }
}

class LoginRequest {
  final String username;
  String password;
  String comanyCode;

  LoginRequest(
      {required this.username, this.password = "", this.comanyCode = ""});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'UserName': username.trim(),
      'Password': password.trim(),
      'CompanyCode': comanyCode.trim(),
    };

    return map;
  }
}
