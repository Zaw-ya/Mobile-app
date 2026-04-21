import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
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

  ProfileModel({
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
