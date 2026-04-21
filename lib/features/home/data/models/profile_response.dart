import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  final int? cityId;
  final int? userId;
  final String? userName;
  final String? password;
  final String? email;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? primaryContactNo;
  final String? createdOn;
  final int? createdBy;
  final bool? isActive;
  final int? role;

  ProfileResponse({
    this.cityId,
    this.userId,
    this.userName,
    this.password,
    this.email,
    this.gender,
    this.firstName,
    this.lastName,
    this.address,
    this.primaryContactNo,
    this.createdOn,
    this.createdBy,
    this.isActive,
    this.role,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}
