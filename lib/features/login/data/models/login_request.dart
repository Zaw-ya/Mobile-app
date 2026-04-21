import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  String? username;
  String? password;
  String? deviceId;

  LoginRequest({this.username, this.password, this.deviceId});

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
