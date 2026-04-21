import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  String? firstName;
  String? lastName;
  String? roleName;
  String? token;
  String? expiration;
  String? title;
  int? status;

  LoginResponse(
      {this.firstName,
      this.lastName,
      this.roleName,
      this.token,
      this.expiration,
      this.title,
      this.status});

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
