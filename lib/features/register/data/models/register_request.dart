import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  String? firstName;
  String? lastName;
  String? userName;
  String? password;
  String? role;
  String? gender;
  String? email;
  String? phoneNumber;
  int? cityId;

  RegisterRequest(
      {this.email,
      this.firstName,
      this.lastName,
      this.userName,
      this.password,
      this.role,
      this.gender,
      this.phoneNumber,
      this.cityId});

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}
